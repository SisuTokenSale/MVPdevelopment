class SourceCustomer < Customer
  # INFO: Dwolla, Can be in range [unverified personal business receive-only]
  attribute :customer_type, :string, default: 'personal'

  def business_name
    "[Source] #{user.human_name}"
  end
end
