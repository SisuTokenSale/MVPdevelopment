class SourceAccountsController < AccountsController
  def create
    param! :source_account, Hash, required: true do |a|
      a.param! :plaid_token, String, required: true
      a.param! :uid, String, required: true
      a.param! :name, String, required: true
      a.param! :institution, String, required: true
      a.param! :account_type, String, required: true
      a.param! :iso_currency_code, String, required: true
      a.param! :balance, Float, required: true, default: 0.0
    end
    @source_account = current_user.source_accounts.new(params.require(:source_account).permit(*permitted_attrs))

    if @source_account.save
      head :no_content, status: :created
    else
      render template: 'source_accounts/new', status: :unprocessable_entity
    end
  end

  def new
    source_account
  end
end
