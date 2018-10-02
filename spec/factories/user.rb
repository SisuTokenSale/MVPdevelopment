FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email.#{n + 1}@sisu.com" }
    password 'password'
    password_confirmation(&:password)
  end
end
