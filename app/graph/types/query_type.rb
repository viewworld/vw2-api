QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root for this schema"

  field :form do
    type FormType
    argument :id, !types.ID
    resolve -> (obj, args, ctx) {
      Form.find(args[:id])
    }
  end
end
