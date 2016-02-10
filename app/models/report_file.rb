class ReportFile < ActiveRecord::Base
  has_attached_file :file, path: ":rails_root/public/system/:class/:id/:style/:filename",
                           url: "/files/:id/:style/:filename"
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
end
