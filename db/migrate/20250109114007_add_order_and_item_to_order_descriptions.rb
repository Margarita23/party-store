class AddOrderAndItemToOrderDescriptions < ActiveRecord::Migration[7.0]
  def change
    add_reference :order_descriptions, :order, null: false, foreign_key: true
    add_reference :order_descriptions, :item, null: false, foreign_key: true
  end
end
