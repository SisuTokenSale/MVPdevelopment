class InvestTransactionsController < ApplicationController
  layout false
  before_action :authenticate_user!

  def create
    @invest_transaction = invest_set.invest_transactions.create(invest_transaction_params)
    render template: 'invest_transactions/new'
  end

  private

  def invest_transaction_params
    params.require(:invest_transaction).permit(%i[amount])
  end
end
