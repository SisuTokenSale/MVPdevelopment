FactoryBot.define do
  factory :source_account do
    account_id SecureRandom.hex(30)
    balance 0.0
  end

  factory :invest_account do
    account_id SecureRandom.hex(30)
    balance 0.0
  end
end
