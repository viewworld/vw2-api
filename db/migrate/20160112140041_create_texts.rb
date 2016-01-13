class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :title
      t.string :hint
      t.string :default_value
      t.references :form, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
