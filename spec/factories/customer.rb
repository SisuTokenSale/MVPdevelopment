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
end
