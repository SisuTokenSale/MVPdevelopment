FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email.#{n + 1}@sisu.com" }
    # access_token "access-#{ENV['PLAID_ENV']}-6a505352-6c5c-45de-b1a1-c9764ed7d18b"
    password 'password'
    password_confirmation(&:password)
  end
end
