class ItemsController < ActionController::API
    def index
        @items = Item.all
        render json: @items
    end
end
