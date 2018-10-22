class DwollaFetchTokensJob < ApplicationJob
  queue_as :dwolla_fetch_tokens

  def perform(*args)
    Processors::Dwolla::FetchTokens.new(args).process!
  end
end
