class ReportFile < ActiveRecord::Base
  has_attached_file :file, path: ":rails_root/public/system/:class/:id/:style/:filename",
                           url: "/files/:id/:style/:filename"
  validates_attachment_content_type :file,
    content_type: /\Aimage\/.*\Z/,
    if: :is_image?

  validates_attachment_content_type :file,
    content_type: /\Avideo\/.*\Z/,
    if: :is_video?

  def is_image?
    file.content_type =~ %r(image)
  end

  def is_video?
    file.content_type =~ %r(video)
  end
end
