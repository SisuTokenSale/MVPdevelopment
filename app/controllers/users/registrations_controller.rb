module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters, only: %i[create update]
    prepend_before_action :check_captcha, only: %i[create]

    def create
      super
    end

    def update
      super
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer
        .permit(:sign_up, keys: %i[password password_confirmation terms email])
    end

    private

    def check_captcha
      configure_permitted_parameters
      return if verify_recaptcha

      self.resource = resource_class.new sign_up_params
      resource.validate
      set_minimum_password_length

      clean_up_passwords(resource)
      render action: 'new'
    end
  end
end
