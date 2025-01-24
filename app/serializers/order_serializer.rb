class OrderSerializer < ActiveModel::Serializer
  attributes :id, :amount, :created_at, :updated_at

	has_many :items

  def items
    object.items.map do |item|
      description = object.order_descriptions.find { |od| od.item_id == item.id }
      item.as_json.merge(quantity: description&.quantity)
    end
  end
end
