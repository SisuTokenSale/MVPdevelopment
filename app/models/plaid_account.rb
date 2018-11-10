class PlaidAccount
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :uid, :available_balance, :current_balance, :iso_currency_code, :name,
                :type, :subtype, :official_name, :institution_id, :institution_name, :dwolla_token

  def currency_symbol
    Money::Currency.new(iso_currency_code).symbol
  end

  def attributes
    {
      'uid' => account_id,
      'available_balance' => available_balance,
      'current_balance' => current_balance,
      'iso_currency_code' => iso_currency_code,
      'name' => name,
      'type' => type,
      'subtype' => subtype,
      'official_name' => official_name,
      'institution_id' => institution_id,
      'institution_name' => institution_name,
      'dwolla_token' => dwolla_token
    }
  end
end
