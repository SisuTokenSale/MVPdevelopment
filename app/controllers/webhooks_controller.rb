class WebhooksController < ApplicationController
  layout false
  # TODO: After DEBUG
  # before_action :verify_signature

  def create
    # TODO: This only for debug Webhooks data from Dwolla
    UserMailer.with(
      email: 'dmitriy.bielorusov@syndicode.com',
      subject: 'Dwolla Retrieve Webhook',
      message: payload_body.to_s + " SIGNATURE: #{request_signature}"
    ).transaction_mail.deliver_now
  end

  private

  def payload_body
    params
  end

  def request_signature
    headers['X-Request-Signature-Sha-256']
  end

  # TODO: After DEBUG
  # def verify_signature
  #   halt(500, "Signatures didn't present!") unless  request_signature
  #   signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['DWOLLA_WEBHOOK_SECRET'], payload_body)
  #   unless Rack::Utils.secure_compare(signature, request_signature)
  #     halt 500, "Signatures didn't match!"
  #   end
  # end
end
