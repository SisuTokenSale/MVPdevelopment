FactoryBot.define do
  factory :account do
    uid { PLAID_CFG[:source_account_id] }
    balance { 0.0 }
    plaid_token { PLAID_CFG[:access_token] }
    dwolla_token { SecureRandom.hex(30) }

    trait :with_usd do
      after(:build) do |account|
        account.iso_currency_code = 'USD'
      end
    end
    trait :with_eur do
      after(:build) do |account|
        account.iso_currency_code = 'EUR'
      end
    end
    trait :with_gbp do
      after(:build) do |account|
        account.iso_currency_code = 'GBP'
      end
    end
    trait :with_funding_source do
      after(:build) do |account|
        customer = account.user.profile.source_customer
        account.funding_source = build(:funding_source, account: account, customer: customer)
      end
    end
  end

  factory :source_account do
    uid { PLAID_CFG[:source_account_id] }
    balance { 0.0 }
    plaid_token { PLAID_CFG[:access_token] }
    dwolla_token { SecureRandom.hex(30) }
    trait :with_funding_source do
      after(:build) do |account|
        customer = account.user.profile.source_customer
        account.funding_source = build(:funding_source, account: account, customer: customer)
      end
    end
  end

  factory :invest_account do
    uid { PLAID_CFG[:invest_account_id] }
    balance { 0.0 }
    plaid_token { PLAID_CFG[:access_token] }
    dwolla_token { SecureRandom.hex(30) }
    trait :with_funding_source do
      after(:build) do |account|
        customer = account.user.profile.invest_customer
        account.funding_source = build(:funding_source, account: account, customer: customer)
      end
    end
  end
end
