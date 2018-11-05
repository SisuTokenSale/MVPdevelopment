class PlaidFetchIdentityJob < ApplicationJob
  queue_as :plaid_fetch_identity

  def perform(*args)
    Processors::Plaid::FetchIdentity.new(args).process!
  end
end
