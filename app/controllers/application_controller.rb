class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :except => [:top, :about]
	before_action :configure_permitted_parameters, if: :devise_controller?

    protected
    def after_sign_in_path_for(resource)
      user_path(resource)
    end

    def after_sign_out_path_for(resource)
      root_path
    end

    # deviseのストロングパラメーター記述
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [
        :email,
        :name,
        :postcode,
        :prefecture_code,
        :address_city,
        :address_street,
        :address_building
        ])
    end

end
