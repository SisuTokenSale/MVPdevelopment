class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :invest_set, :source_account, :invest_account, only: :index

  def index; end
end
