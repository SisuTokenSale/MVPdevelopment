FactoryBot.define do
  factory :invest_set do
    amount { 5.0 }
    frequency { 'daily' }
    strategy { 'default' }

    trait :with_accounts do
      after(:build) do |invest_set|
        invest_set.source_account = create(:source_account, user: invest_set.user)
        invest_set.invest_account = create(:invest_account, user: invest_set.user)
      end
    end
  end
end
