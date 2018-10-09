FactoryBot.define do
  factory :source_account do
    uid { SecureRandom.hex(30) }
    current_balance { 0.0 }
    available_balance { 0.0 }
  end

  factory :invest_account do
    uid { SecureRandom.hex(30) }
    current_balance { 0.0 }
    available_balance { 0.0 }
  end
end
