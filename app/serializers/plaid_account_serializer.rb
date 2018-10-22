class PlaidAccountSerializer < ActiveModel::Serializer
  attributes :uid, :available_balance,
             :current_balance, :iso_currency_code,
             :name, :type, :subtype, :official_name, :full_name,
             :institution_id, :institution_name, :disabled

  def full_name
    "#{object.available_balance} #{object.iso_currency_code} - #{object.official_name}"
  end

  def disabled
    object.dwolla_token.nil?
  end
end
