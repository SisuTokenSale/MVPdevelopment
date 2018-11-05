class InvestSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :invest_set_transactions, only: %i[create new]

  layout false

  def create
    iss = InvestSetService.new(user: current_user).create(
      invest_set: invest_set_params, invest_transaction: invest_transaction_params
    )
    @invest_set = iss&.invest_set
    @invest_transaction = iss&.invest_transaction

    if iss.valid?
      render template: 'invest_sets/show'
    else
      render template: 'invest_sets/new', status: :unprocessable_entity
    end
  end

  def transactions
    param! :q, Hash do |a|
      a.param! :status_in, Array, default: InvestTransaction::STATUSES
    end
    @invest_set_transactions = invest_set_transactions.ransack(params[:q]).result
    render partial: 'invest_sets/transactions/items'
  end

  def new
    invest_set && invest_transaction
  end

  private

  def invest_set_params
    params.require(:invest_set).permit(%i[amount frequency])
  end

  def invest_transaction_params
    params.require(:invest_transaction).permit(%i[amount required])
  end
end
