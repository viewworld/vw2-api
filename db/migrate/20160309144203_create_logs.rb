class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :subject_id, null: false
      t.string :subject_type, null: false

      t.timestamps null: false
      t.string :activity
    end
  end
end
