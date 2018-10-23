FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email.#{n + 1}@sisu.com" }
    password { 'password' }
    password_confirmation(&:password)

    trait :with_source_accounts do
      after(:create) do |user|
        create_list(:source_account, 2, user: user)
      end
    end

    trait :with_invest_accounts do
      after(:create) do |user|
        create_list(:invest_account, 2, user: user)
      end
    end

    trait :with_invest_sets do
      after(:create) do |user|
        create_list(:invest_set, 2, :with_accounts, user: user)
      end
    end
  end
end
