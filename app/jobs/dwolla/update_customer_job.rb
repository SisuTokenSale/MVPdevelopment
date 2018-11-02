module Dwolla
  class UpdateCustomerJob < ApplicationJob
    queue_as :dwolla

    def perform(profile_id)
      profile = Profile.find(profile_id)

      ::Processors::Dwolla::CustomerProcessor.call(profile)
    end
  end
end
