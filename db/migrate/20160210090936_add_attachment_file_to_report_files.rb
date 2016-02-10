class AddAttachmentFileToReportFiles < ActiveRecord::Migration
  def self.up
    change_table :report_files do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :report_files, :file
  end
end
