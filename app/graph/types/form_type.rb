FormType = GraphQL::ObjectType.define do
  name "Form"
  description "Form"
  field :name, types.String
  field :data, types.String
end
