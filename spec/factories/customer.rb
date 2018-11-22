FactoryBot.define do
  factory :customer do
    link { File.join('https://api-sandbox.dwolla.com/customers', SecureRandom.uuid) }
    customer_type { 'unverified' }
    status { 'unverified' }
    trait :with_profile do
      after(:build) do |customer|
        customer.profile = create(:profile)
      end
    end
  end

  factory :source_customer do
    link { File.join('https://api-sandbox.dwolla.com/customers', SecureRandom.uuid) }
    status { 'verified' }
  end

  factory :invest_customer do
    link { File.join('https://api-sandbox.dwolla.com/customers', SecureRandom.uuid) }
    status { 'unverified' }
  end
end
