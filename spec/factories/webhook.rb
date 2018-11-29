FactoryBot.define do
  factory :dwolla_webhook do
    link { File.join('https://api-sandbox.dwolla.com/webhook-subscriptions', SecureRandom.uuid) }
  end
end
