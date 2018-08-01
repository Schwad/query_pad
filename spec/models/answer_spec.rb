require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

  context 'valid answer' do
    it 'increments the answer score without triggering callbacks' do
      expect(answer.score).to eq(0)
      answer.increment_score
      expect(Answer.last.score).to eq(1)
      expect(answer.score).to eq(0)
    end

    it 'decrements the answer score without triggering callbacks' do
      expect(answer.score).to eq(0)
      answer.decrement_score
      expect(Answer.last.score).to eq(-1)
      expect(answer.score).to eq(0)
    end

    it '#question_title' do
      expect(answer.question_title).to eq(question.title)
    end
  end
end
