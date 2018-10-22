class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(_resource)
    dashboard_index_path
  end

  private

  def invest_set
    @invest_set ||= current_user.current_invest_set
  end

  def source_account
    @source_account ||= invest_set&.source_account || current_user.last_source_account
  end

  def invest_account
    @invest_account ||= invest_set&.invest_account || current_user.last_invest_account
  end
end
