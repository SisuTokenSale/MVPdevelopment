class DwollaUpdateProfileCustomersJob < ApplicationJob
  queue_as :dwolla_update_profile_customers

  def perform(opts = {})
    return unless opts[:id]

    Processors::Dwolla::UpdateCustomer.new(profile: Profile.find(opts[:id])).process!
  end
end
