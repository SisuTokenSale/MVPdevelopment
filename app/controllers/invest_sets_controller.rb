class InvestSetsController < ApplicationController
  before_action :authenticate_user!
  layout false

  def create
    param! :invest_set, Hash, required: true do |a|
      a.param! :frequency, String, required: true
      a.param! :strategy, String, default: 'default'
      a.param! :amount, Float, default: 0.0
      a.param! :lowest, Integer, default: 0
    end

    set_prms = params.require(:invest_set).permit(permitted_attrs)
    @invest_set = current_user.invest_sets.new(set_prms)
    @invest_set.source_account =  current_user.current_invest_set&.source_account || current_user.last_source_account
    @invest_set.invest_account =  current_user.current_invest_set&.invest_account || current_user.last_invest_account

    @invest_set.save ? redirect_to(dashboard_index_url) : render(action: 'new')
  end

  def new
    invest_set
  end

  private

  def permitted_attrs
    %i[strategy amount frequency lowest]
  end
end
