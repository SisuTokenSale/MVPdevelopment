FactoryBot.define do
  factory :event do
    topic { 'customer_transfer_created' }
    link { File.join('https://api-sandbox.dwolla.com/events', SecureRandom.uuid) }
    object_class { 'InvestTransaction' }
    status { 'processed' }
    resource_id { SecureRandom.uuid }
  end
end
