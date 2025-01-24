# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
    respond_to :json

    def update
      user = User.find_by(email: params[:email])
  
      unless user
        return render json: {
          status: { message: "User with the provided email was not found." }
        }, status: :not_found
      end
  
      unless params[:password].present? && params[:password_confirmation].present?
        return render json: {
          status: { message: "Password and password confirmation are required." }
        }, status: :unprocessable_entity
      end
  
      unless params[:password] == params[:password_confirmation]
        return render json: {
          status: { message: "Password and password confirmation do not match." }
        }, status: :unprocessable_entity
      end
  
      if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        render json: {
          status: { code: 200, message: "Password updated successfully." },
          data: UserSerializer.new(user).serializable_hash[:data][:attributes]
        }, status: :ok
      else
        render json: {
          status: { message: "Password update failed. #{user.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end

end
  