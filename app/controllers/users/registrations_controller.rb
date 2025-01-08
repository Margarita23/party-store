# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController  

  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: { code: 200, message: 'Signed up successfully.'},
        token: @token,
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  def after_sign_up_path_for(resource)
    items_path
  end

  def after_inactive_sign_up_path_for(resource)
    items_path
  end

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   # super(resource)
  #   items_path
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
