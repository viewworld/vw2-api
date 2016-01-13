class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :name
      t.jsonb :data

      t.timestamps null: false
    end
    add_index :forms, :data, using: :gin
  end
end
