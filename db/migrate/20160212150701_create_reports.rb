class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :form, index: true, foreign_key: true
      t.jsonb :data
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
      t.integer :status
    end
    add_index :reports, :data, using: :gin
  end
end
