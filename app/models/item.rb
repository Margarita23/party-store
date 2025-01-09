class Item < ApplicationRecord
    has_many :order_descriptions, dependent: :destroy
    has_many :orders, through: :order_descriptions
end
