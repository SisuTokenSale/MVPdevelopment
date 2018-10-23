class ApplicationController < ActionController::Base
  rescue_from AppExceptions::BaseException, with: :render_error_response

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

  def render_error_response(error)
    return unless request.format.json?

    render json: error, serializer: AppExceptionSerializer, status: error.code
  end
end
