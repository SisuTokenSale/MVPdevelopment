class PlaidIdentity
  include Serializable
  attr_accessor :names, :address, :email, :phones

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
