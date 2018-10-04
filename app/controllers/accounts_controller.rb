class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def new; end

  def create
    acc_type = params.keys.detect { |k| k =~ /.*_account\z/ }
    acc_attrs = params.require(acc_type).permit(:account_id)
    acc_attrs[:balance] = plaid_service.balance(account_id: acc_attrs[:account_id])

    if current_user.send("create_#{acc_type}", acc_attrs)
      redirect_to user_url
    else
      render :new
    end
  end

  def destroy
    Account.accessible_by(current_ability).destroy_all
    redirect_to user_url
  end

  def show
    @account_data = plaid_service.account_data(account_id: account.account_id)
    @transactions_data = plaid_service.transactions(accounts_id: account.account_id)
  end

  private

  def plaid_service
    @plaid_service ||= PlaidService.new(access_token: current_user.access_token)
  end

  helper_method :accounts
  def accounts
    @accounts ||= plaid_service.accounts
  end

  helper_method :account
  def account
    @account ||= Account.accessible_by(current_ability).find_by(id: params[:id]) || acc_class.new
  end

  def acc_class
    raise 'Unavailable resource!' unless params[:type]&.in?(%w[Invest Source])

    "#{params[:type]}Account".constantize
  end
end
