class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  layout false

  def create
    WebhookService.new(
      webhook: params[:webhook][:resourceId] ? params[:webhook] : extract_params,
      request_signature: request_signature
    ).create_event!
  rescue StandardError => error
    Rails.logger.info(error)
    render json: { error: error }, status: :unprocessable_entity
  end

  private

  def extract_params
    params.slice(:id, :resourceId, :topic, :timestamp, :_links, :created)
  end

  def request_signature
    request.headers['HTTP_X_REQUEST_SIGNATURE_SHA_256']
  end
end
