class SourceCustomer < Customer
  # INFO: Dwolla, Can be in range [unverified personal business receive-only]
  attribute :customer_type, :string, default: 'unverified'

  def business_name
    "SC:#{user.id}:#{id}"
  end
end
