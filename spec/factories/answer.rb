FactoryBot.define do
  factory :answer do
    body 'It is whatever you wish it to be.'
    user
    question
  end
end
