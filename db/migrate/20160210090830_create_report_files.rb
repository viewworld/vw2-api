class CreateReportFiles < ActiveRecord::Migration
  def change
    create_table :report_files do |t|

      t.timestamps null: false
    end
  end
end
