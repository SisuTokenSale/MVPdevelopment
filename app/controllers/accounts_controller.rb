class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
  end

  def create
    acc_type = params.keys.detect{ |k| k =~ /.*_account\z/}
    acc_class = acc_type.classify.constantize

    acc_attrs = params.require(acc_type).permit(:account_id)
    acc_balance = accounts.detect { |acc| acc.account_id == acc_attrs[:account_id] }[:balances][:current]
    acc_attrs.merge!(balance: acc_balance)

    if current_user.send("create_#{acc_type}", acc_attrs)
      redirect_to user_url
    else
      render :new
    end
  end

  def destroy
    acc_class.where(user: current_user).destroy_all
    redirect_to user_url
  end

  def show
    @account_data = accounts.detect { |acc| acc.account_id == account.account_id }
    @transactions_data = transactions.select { |trn| trn[:account_id] == account.account_id }
  end

  private

  helper_method :accounts
  def accounts
    @_accounts ||= $plaid.auth
                         .get(current_user.access_token)
                         .with_indifferent_access[:accounts]
                         .map { |acc| OpenStruct.new(acc) }
  end

  helper_method :account
  def account
    @_account ||= Account.find_by(id: params[:id]) || acc_class.new
  end

  def transactions
    @_transactions ||= $plaid.transactions.get(current_user.access_token, 6.months.ago, Date.current)[:transactions]
  end

  def acc_class
    type = params[:type]
    # raise unless %w[Invest Source].include?(type)
    raise unless type.in? %w[Invest Source]
    "#{type}Account".constantize
  end
end
