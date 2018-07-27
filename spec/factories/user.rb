FactoryBot.define do
  factory :user do
    name 'John Doe'
    email { Faker::Internet.email }
    provider 'google_oauth2'
    uid { Faker::Number.number(10) }
  end
end
