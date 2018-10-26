class PlaidAccountSerializer < ActiveModel::Serializer
  attributes :uid, :available_balance,
             :current_balance, :iso_currency_code, :currency_symbol,
             :name, :type, :subtype, :official_name, :full_name,
             :institution_id, :institution_name, :disabled

  def full_name
    "#{object.currency_symbol}#{object.available_balance} - #{object.official_name}"
  end

  def disabled
    object.dwolla_token.nil?
  end
end
