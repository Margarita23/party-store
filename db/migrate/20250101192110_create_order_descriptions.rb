class CreateOrderDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :order_descriptions do |t|
      t.integer :quantity, presence: true
      t.check_constraint 'quantity >= 0', name: 'quantity_non_negative'

      t.timestamps
    end
  end
end
