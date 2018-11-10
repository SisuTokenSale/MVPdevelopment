class InvestTransactionsController < ApplicationController
  layout false
  before_action :authenticate_user!

  def create
    @invest_transaction = invest_set.invest_transactions.new(invest_transaction_params)
    head(:no_content, status: :created) && return if @invest_transaction.save
    render template: 'invest_transactions/new', status: :unprocessable_entity
  end

  private

  def invest_transaction_params
    params.require(:invest_transaction).permit(%i[amount])
  end
end
