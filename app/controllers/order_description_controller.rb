class OrderDescriptionsController < ActionController::API
    before_action :authenticate_user!
  
    def update
      order_description = OrderDescription.find(params[:id])
      if order_description.update(order_description_params)
        render json: order_description
      else
        render json: { errors: order_description.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def order_description_params
      params.require(:order_description).permit(:item_id, :quantity)
    end
  end
  