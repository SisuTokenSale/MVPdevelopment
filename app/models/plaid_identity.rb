class PlaidIdentity
  include Serializable
  attr_accessor :names, :address, :email, :phones

  def verified_customer_request_body(opts = {})
    {
      businessName: opts[:name],
      firstName: opts[:first_name] || first_name,
      lastName: opts[:last_name] || last_name,
      email: opts[:email] || email,
      type: opts[:type] || 'personal',
      address1: opts[:street] || address['street'],
      city: opts[:city] || address['city'],
      state: opts[:state] || address['state'],
      postalCode: opts[:zip] || address['zip'],
      dateOfBirth: opts[:dob]&.strftime('%Y-%m-%d'),
      ssn: opts[:ssn]&.last(4)
    }
  end

  def profile_info
    {
      first_name: first_name,
      last_name: last_name,
      street: address['street'],
      city: address['city'],
      state: address['state'],
      zip: address['zip']
    }
  end

  def full_name
    names&.first
  end

  def first_name
    full_name.split(/\s/)&.first
  end

  def last_name
    full_name.gsub(/#{first_name}\s+/, '')
  end
end
