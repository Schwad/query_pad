require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:vote) { create(:vote, votable: question, user: user) }

  it 'applies score update to user, votable' do
    Vote.create(
      user_id: user.id,
      votable_id: question.id,
      votable_type: 'Question'
    )
    expect(User.first.score).to eq(2)
    expect(Question.first.score).to eq(2)
  end

  it 'reverses score update to user, votable' do
    vote.destroy
    expect(User.first.score).to eq(0)
    expect(Question.first.score).to eq(0)
  end
end
