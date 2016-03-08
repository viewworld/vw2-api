class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, index: true, unique: true
      t.string :login
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.string :timezone_name
      t.string :time_zone
      t.integer :role, default: 3
      t.references :group, index: true, foreign_key: true

      t.timestamps
    end
  end
end
