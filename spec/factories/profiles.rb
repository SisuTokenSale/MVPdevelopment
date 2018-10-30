FactoryBot.define do
  factory :profile do
    user
    first_name { 'Some name' } # TODO: add faker
    last_name { 'Some last name' }
  end
end
