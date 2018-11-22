class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  # TODO: Will be before_action :verify_signature!
  layout false

  def create
    # TODO: This only for debug Webhooks data from Dwolla
    UserMailer.with(
      email: 'dmitriy.bielorusov@syndicode.com',
      subject: 'Dwolla Retrieve Webhook',
      message: hook_params.to_s + " SIGNATURE: #{request_signature}"
    ).transaction_mail.deliver_now

    head :no_content, status: :created
  end

  private

  def request_signature
    request.headers['HTTP_X_REQUEST_SIGNATURE_SHA_256']
  end

  # TODO: After DEBUG
  # def verify_signature!
  #   head(:no_content, status: :unprocessible_entity) && return if request_signature.blank?
  #   signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['DWOLLA_WEBHOOK_SECRET'], hook_params.to_s)
  #   unless Rack::Utils.secure_compare(signature, request_signature)
  #     head(:no_content, status: :unprocessible_entity) && return
  #   end
  # end

  def hook_params
    params.permit(%i[id resourceId topic timestamp _links created])
  end
end
