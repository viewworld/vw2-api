FactoryGirl.define do
  factory :form do
    name "MyString"
    data [{"id"=>1, "hint"=>{"en"=>"name of species"}, "type"=>"text", "items"=>{"report"=>nil}, "title"=>{"en"=>"What species did you see?"}, "editable"=>true, "required"=>true},
          {"id"=>2, "hint"=>{"en"=>"name of species"}, "type"=>"text", "items"=>{"report"=>nil}, "title"=>{"en"=>"What species did you see?"}, "editable"=>true, "required"=>true},
          {"id"=>3, "hint"=>{"en"=>"fileupload"}, "type"=>"media", "items"=>{"report"=>nil}, "title"=>{"en"=>"upload file?"}, "editable"=>true, "required"=>true}]
    organisation
  end
end
