class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.jsonb :data
      t.string :field_data
      t.references :report, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :texts, :data, using: :gin
  end
end
