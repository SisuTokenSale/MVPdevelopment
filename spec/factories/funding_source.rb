FactoryBot.define do
  factory :funding_source do
    link { File.join('https://api-sandbox.dwolla.com/funding-sources', SecureRandom.uuid) }

    trait :pending do
      after(:build) do |funding_source|
        funding_source.status = 'pending'
      end
    end

    trait :processed do
      after(:build) do |funding_source|
        funding_source.status = 'processed'
      end
    end

    trait :failed do
      after(:build) do |funding_source|
        funding_source.status = 'failed'
      end
    end

    trait :with_customer do
      after(:build) do |funding_source|
        funding_source.customer = create(:customer, :with_profile)
      end
    end
  end
end
