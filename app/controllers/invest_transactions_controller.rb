class InvestTransactionsController < ApplicationController
  layout false
  before_action :authenticate_user!

  def create
    # INFO: Create only one type transaction
    @invest_transaction = invest_set.invest_transactions.new(invest_transaction_params)
    head(:no_content, status: :created) && return if @invest_transaction.save
    render template: 'invest_transactions/new', status: :unprocessable_entity
  end

  def destroy
    @invest_transaction = current_user.invest_set_transactions.for_cancelling.find(params[:id])
    @invest_transaction.cancelled!
  end

  private

  def invest_transaction_params
    params.require(:invest_transaction).permit(%i[amount investment_type])
  end
end
