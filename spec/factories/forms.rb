FactoryGirl.define do
  factory :form do
    name "MyString"
    groups [1, 2]
    data [{"id"=>1, "hint"=>"name of species", "type"=>"text", "items"=>{}, "title"=>"What species did you see?", "editable"=>true, "required"=>true, "length" => [1, 10]},
          {"id"=>2, "hint"=>"name of species", "type"=>"text", "items"=>{}, "title"=>"What species did you see?", "editable"=>true, "required"=>true, "length" => [1, 10]}]
    order [2, 1]
    organisation
  end
end
