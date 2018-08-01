require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  context 'valid question' do
    it 'increments the question score without triggering callbacks' do
      expect(question.score).to eq(0)
      question.increment_score
      expect(Question.last.score).to eq(1)
      expect(question.score).to eq(0)
    end

    it 'decrements the question score without triggering callbacks' do
      expect(question.score).to eq(0)
      question.decrement_score
      expect(Question.last.score).to eq(-1)
      expect(question.score).to eq(0)
    end
  end
end
