class DwollaRegisterProfileCustomersJob < ApplicationJob
  queue_as :dwolla_register_profile_customers

  def perform(opts = {})
    return unless opts[:id]

    Processors::Dwolla::RegisterCustomer.new(profile: Profile.find(opts[:id])).process!
  end
end
