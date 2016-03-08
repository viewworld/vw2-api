class AddAttachmentFileToSignatures < ActiveRecord::Migration
  def self.up
    change_table :signatures do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :signatures, :file
  end
end
