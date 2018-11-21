FactoryBot.define do
  factory :profile do
    user
    first_name { 'Some name' } # TODO: add faker
    last_name { 'Some last name' }
    dob { 21.years.ago.to_date }
    sequence(:ssn) { |n| "111-222-33#{n + 1}" }
  end
end
