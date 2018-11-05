class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :invest_set,
                :invest_set_transactions,
                :source_account,
                :invest_account,
                :invest_transaction, only: :index

  def index; end
end
