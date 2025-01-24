class UsersController < ActionController::API  
	respond_to :json
  before_action :authenticate_user!

  def index
    authorize! :index, User
    
    users = User.all
    render json: {
      status: { code: 200, message: 'Users fetched successfully.' },
      data: users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
    }, status: :ok
  end

  def show
    if current_user
      render json: {
        status: { code: 200, message: 'User profile fetched successfully.' },
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: { code: 404, message: 'User not found.' }
      }, status: :not_found
    end
  end

  def update
    if current_user.update(user_params)
      render json: {
        status: { code: 200, message: 'User profile updated successfully.' },
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: 'Profile update failed.' },
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
