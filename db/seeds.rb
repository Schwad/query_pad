require 'progress_bar'
bar = ProgressBar.new
#Initialize with 100 users
puts 'Seeding Database..'
100.times do
  user = User.create(
    email: Faker::Internet.email,
    name: Faker::Name.name,
    uid: Faker::Number.number(10),
    provider: 'google_oauth2',
    score: (1..55).to_a.sample
  )

  # Build a set of questions

  (2..8).to_a.sample.times do
    built_time = (1..100).to_a.sample.days.ago
    question = Question.create(
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph,
      score: (1..100).to_a.sample,
      user_id: user.id,
      created_at: built_time,
      updated_at: built_time
    )
  end

  # Build a set of answers

  (2..8).to_a.sample.times do
    question = Answer.create(
      body: Faker::Lorem.paragraph,
      user_id: user.id,
      score: (1..55).to_a.sample,
      question_id: Question.all.sample.id
    )
  end
  bar.increment!
end
puts 'Database seeded!'
