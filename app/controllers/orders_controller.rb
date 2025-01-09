class OrdersController < ActionController::API
    before_action :authenticate_user!
  
    def index
      orders = current_user.orders.includes(:items)
      render json: orders, include: :items
    end
  
    def show
      order = current_user.orders.find(params[:id])
      render json: order, include: :items
    end
  
    def create
      order = current_user.orders.build(order_params)
      if order.save
        render json: order, status: :created
      else
        render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      order = current_user.orders.find(params[:id])
      order.destroy
      head :no_content
    end
  
    private
  
    def order_params
      params.require(:order).permit(:amount, order_descriptions_attributes: [:item_id, :quantity])
    end
end
  