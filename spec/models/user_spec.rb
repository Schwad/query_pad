require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with valid authorisation' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:question) { create(:question, user: other_user) }
    let!(:answer) { create(:answer, user: other_user, question: question) }
    let!(:vote) { create(:vote, votable: question, user: user) }
    let!(:vote_answer) { create(:vote, votable: answer, user: user) }

    it 'increments the user score, without triggering update callbacks' do
      expect(user.score).to eq(0)
      user.increment_score
      expect(User.first.score).to eq(1)
      expect(user.score).to eq(0)
    end

    it 'decrements the user score, without triggering update callbacks' do
      expect(user.score).to eq(0)
      user.decrement_score
      expect(User.first.score).to eq(-1)
      expect(user.score).to eq(0)
    end

    it 'flags the user as a power user if the score is high, but not massive' do
      expect(user.power_user).to eq(false)
      user.update_column(:score, 27)
      expect(user.power_user).to eq(true)
      user.update_column(:score, 55)
      expect(user.power_user).to eq(false)
    end

    it 'flags the user as a moderator user if the score is high, but not massive' do
      expect(user.moderator_user).to eq(false)
      user.update_column(:score, 27)
      expect(user.moderator_user).to eq(false)
      user.update_column(:score, 55)
      expect(user.moderator_user).to eq(true)
    end

    it 'returns whether a vote cast on an object is up, down or none' do
      expect(user.vote_cast(question)).to eq('Upvote')
      vote.update_column(:upvote, false)
      expect(user.vote_cast(question)).to eq('Downvote')
      vote.destroy
      expect(user.vote_cast(question)).to eq('None')
    end

    it 'returns the voted questions' do
      expect(user.voted_questions).to include(question)
    end

    it 'returns the voted answers' do
      expect(user.voted_answers).to include(answer)
    end

    it 'returns the questions that were answered' do
      expect(other_user.answered_questions).to include(question)
    end
  end
end
