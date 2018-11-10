class AccountsController < ApplicationController
  layout false

  before_action :authenticate_user!

  private

  def permitted_attrs
    %i[uid name institution institution_id mask account_type public_token]
  end
end
