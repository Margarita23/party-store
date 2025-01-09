class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :amount, precision: 8, scale: 2, presence: true
      t.check_constraint 'amount >= 0', name: 'amount_non_negative'

      t.timestamps
    end
  end
end
