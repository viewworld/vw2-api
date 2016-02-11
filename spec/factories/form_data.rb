FactoryGirl.define do
factory :form_data, class: OpenStruct do
{
"form": {
  "name": "Demo2 Species Observations",
  "groups": [
    1,
    2,
    3
  ],
  "active": true,
  "data": [
    {
      "id": 1,
      "hint": "name of species",
      "type": "text",
      "title": "What species did you see?",
      "editable": true,
      "required": true
    },
    {
      "id": 2,
      "hint": "name of species",
      "type": "text",
      "title": "What species did you see?",
      "editable": true,
      "required": true
    },
    {
      "id": 3,
      "hint": "fileupload",
      "type": "media",
      "title": "upload file?",
      "editable": true,
      "required": true
    }
    ],
    "order": [
      2,
      1,
      3
    ]
}
}
end
end
