class HardenUsersDomainConstraints < ActiveRecord::Migration[7.1]
  def up
    # Backfill to avoid failures when adding NOT NULL constraint
    execute <<~SQL
      UPDATE users
      SET name = 'Unnamed'
      WHERE name IS NULL OR trim(name) = '';
    SQL
    
    
    execute <<~SQL
      UPDATE users
      SET email = concat('user_', id, '@example.local')
      WHERE email IS NULL OR trim(email) = '';
    SQL

    #Constraints apply
    change_column_null :users, :name, false
    change_column_null :users, :email, false
    change_column_null :users, :role, false
  end


  def down
    change_column_null :users, :name, true
    change_column_null :users, :email, true
    change_column_null :users, :role, true
  end  
end
