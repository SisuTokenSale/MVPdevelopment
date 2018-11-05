class ApplicationController < ActionController::Base
  rescue_from AppExceptions::BaseException, with: :render_error_response

  protected

  def after_sign_in_path_for(_resource)
    dashboard_index_path
  end

  private

  def invest_set
    @invest_set ||= current_user.current_invest_set || current_user.invest_sets.new
  end

  def invest_set_transactions
    @invest_set_transactions ||= current_user.invest_set_transactions.limit(10).order(created_at: :desc)
  end

  def invest_transaction
    @invest_transaction ||= invest_set.invest_transactions.new
  end

  def source_account
    @source_account ||= invest_set&.source_account || current_user.last_source_account
  end

  def invest_account
    @invest_account ||= invest_set&.invest_account || current_user.last_invest_account
  end

  def render_error_response(error)
    return unless request.format.json?

    render json: error, serializer: AppExceptionSerializer, status: error.code
  end
end
