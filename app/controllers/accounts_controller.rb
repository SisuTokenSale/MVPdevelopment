class AccountsController < ApplicationController
  layout false

  before_action :authenticate_user!

  private

  def permitted_attrs
    %i[plaid_token uid name institution account_type iso_currency_code balance]
  end
end
