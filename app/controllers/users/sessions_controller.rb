# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :verify_signed_out_user, only: :destroy

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      sign_in(resource_name, resource)
      respond_with(resource, location: after_sign_in_path_for(resource))
    else
      render json: { error: 'Invalid login credentials' }, status: :unauthorized
    end
  end

  def destroy
    token = request.headers['Authorization']&.split(' ')&.last
  
    if token
      jwt_payload = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, algorithm: 'HS256')[0]
      current_user = User.find(jwt_payload['sub'])

      if current_user
        sign_out(current_user)
        render json: {
          status: 200,
          message: "Logged out successfully"
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    else
      render json: {
        status: 401,
        message: "Authorization token is missing."
      }, status: :unauthorized
    end
  rescue JWT::DecodeError => e
    render json: {
      status: 401,
      message: "Invalid token: #{e.message}"
    }, status: :unauthorized
  end

  private

  def respond_with(resource, _opts = {})
    token = request.env['warden-jwt_auth.token']
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      token: token
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session or invalid token."
      }, status: :unauthorized
    end
    rescue JWT::DecodeError
      render json: {
        status: 402,
        message: "Invalid token"
      }, status: :unauthorized
  end

end
