class FixUsersActiveTypeAndRemoveBoolean < ActiveRecord::Migration[7.1]
  def up

    #Remove incorrect column
    remove_column :users, :boolean, :string if column_exists?(:users, :boolean)

    #Convert active from string to boolean
    #Converting common values: 't', 'true', '1', 'yes', 'y' => true, resto => false
    add_column :users, :active_tmp, :boolean, default: true, null: false

    execute <<~SQL
      UPDATE users
      SET active_tmp = 
      CASE
        WHEN active IS NULL THEN true
        WHEN LOWER(active) IN ('t', 'true', '1', 'yes', 'y') THEN true
        ELSE false
      END
    SQL

    remove_column :users, :active
    rename_column :users, :active_tmp, :active

    #Grant default value in role too (good practice)
    change_column_default :users, :role, from: nil, to: 0
  end


  def down
    #Simple reversal
    add_column :users, :active_tmp, :string

    execute <<~SQL
      UPDATE users
      SET active_tmp = CASE WHEN active THEN 't' ELSE 'f' END
    SQL

    remove_column :users, :active
    rename_column :users, :active_tmp, :active
    change_column_default :users, :role, from: 0, to: nil

    #Don't recreate boolean column
  end  
end
