module Users
  class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :check_captcha, only: %i[create]

    def create
      super
    end

    private

    def check_captcha
      return if verify_recaptcha

      self.resource = resource_class.new sign_up_params
      resource.validate
      set_minimum_password_length
      respond_with resource
    end
  end
end
