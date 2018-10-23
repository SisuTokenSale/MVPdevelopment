FactoryBot.define do
  factory :source_account do
    uid { SecureRandom.hex(30) }
    balance { 0.0 }
    plaid_token { SecureRandom.hex(30) }
    dwolla_token { SecureRandom.hex(30) }
  end

  factory :invest_account do
    uid { SecureRandom.hex(30) }
    balance { 0.0 }
    plaid_token { SecureRandom.hex(30) }
    dwolla_token { SecureRandom.hex(30) }
  end
end
