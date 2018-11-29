class DwollaInitWebhookJob < ApplicationJob
  queue_as :dwolla_init_webhook

  def perform(opts = {})
    Processors::Dwolla::InitWebhook.new(opts).process!
  end
end
