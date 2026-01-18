class AddConstraintsToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :active, from: nil, to: true
    change_column_default :users, :role, from: nil, to: 0

    add_index :users, :email, unique: true
  end
end
