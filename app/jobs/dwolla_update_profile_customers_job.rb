class DwollaUpdateProfileCustomersJob < ApplicationJob
  queue_as :dwolla_update_profile_customers

  def perform(opts = {})
    return unless opts[:id]

    Customer.transaction do
      profile = Profile.find(opts[:id])
      Processors::Dwolla::UpdateCustomer.new(customer: profile.source_customer).process!
      Processors::Dwolla::UpdateCustomer.new(customer: profile.invest_customer).process!
    end
  end
end
