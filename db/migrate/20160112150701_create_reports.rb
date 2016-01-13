class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :form, index: true, foreign_key: true
      t.jsonb :data

      t.timestamps null: false
    end
    add_index :reports, :data, using: :gin
  end
end
