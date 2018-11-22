class DwollaFetchWebhooksJob < ApplicationJob
  queue_as :dwolla_fetch_webhooks

  def perform
    Processors::Dwolla::FetchWebhooks.new.process!
  end
end
