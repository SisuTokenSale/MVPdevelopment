class DwollaRegisterProfileCustomersJob < ApplicationJob
  queue_as :dwolla_register_profile_customers

  def perform(opts = {})
    return unless opts[:id]

    Customer.transaction do
      profile = Profile.find(opts[:id])

      Processors::Dwolla::RegisterCustomer.new(profile: profile, customer_type: 'source').process!
      Processors::Dwolla::RegisterCustomer.new(profile: profile, customer_type: 'invest').process!
    end
  end
end
