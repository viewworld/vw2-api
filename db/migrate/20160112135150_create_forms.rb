class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :name
      t.jsonb :data
      t.boolean :active, default: false
      t.boolean :verification_required, default: false
      t.string :verification_default, default: "verified"
      t.text :groups, array: true, default: []
      t.text :order, array: true, default: []

      t.timestamps null: false
    end
    add_index :forms, :data, using: :gin
  end
end
