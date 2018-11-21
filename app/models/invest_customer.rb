class InvestCustomer < Customer
  # INFO: Dwolla, Can be in range [unverified personal business receive-only]
  attribute :customer_type, :string, default: 'unverified'

  # INFO: Should be different from Source Customer
  # SourceCustomer: admin@gmail.com => InvestCustomer: admin+1@gmail.com
  def email
    return unless super

    super.gsub('@', '+1@')
  end

  def business_name
    "IC:#{user.id}:#{id}"
  end
end
