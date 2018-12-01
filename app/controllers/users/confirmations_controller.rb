module Users
  class ConfirmationsController < Devise::ConfirmationsController
    private

    def after_confirmation_path_for(_resource_name, resource)
      Mailer.new_account_created(resource).deliver_later
      sign_in(resource) # INFO: In case you want to sign in the user
      dashboard_index_path
    end
  end
end
