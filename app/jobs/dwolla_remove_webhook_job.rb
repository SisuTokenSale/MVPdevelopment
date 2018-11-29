class DwollaRemoveWebhookJob < ApplicationJob
  queue_as :dwolla_remove_webhook

  def perform(opts = {})
    Processors::Dwolla::RemoveWebhook.new(opts).process!
  end
end
