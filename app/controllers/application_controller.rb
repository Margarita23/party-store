class ApplicationController < ActionController::API
    before_action :configure_permitted_parameters, if: :devise_controller?

    rescue_from CanCan::AccessDenied do |exception|
        render json: {
          status: { code: 403, message: 'You are not authorized to perform this action.' }
        }, status: :forbidden
    end
    
    protected
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name])
        devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name])
    end

    private

    def handle_unauthorized
        render json: { message: 'Unauthorized' }, status: :unauthorized
    end
end
