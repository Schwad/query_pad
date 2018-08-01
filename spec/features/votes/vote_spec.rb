require 'rails_helper'
feature 'Votes' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question)}
  let!(:other_user) { create(:user) }
  let!(:other_question) { create(:question, user: other_user, title: 'Where do I find the nearest food truck?') }
  let!(:other_answer) { create(:answer, user: other_user, question: other_question)}

  context 'normal authorised user' do

    before(:each) do
      login_as(user, scope: :user)
      visit question_path(other_question)
    end

    scenario 'can upvote question' do
      within('#question') do
        click_on '⬆️'
      end
      expect(page).to have_content('👍')
      expect(other_question.votes.count).to eq(1)
      expect(user.votes.count).to eq(1)
    end

    scenario 'can upvote answer' do
      within('#answers') do
        click_on '⬆️'
      end
      expect(page).to have_content('👍')
      expect(other_answer.votes.count).to eq(1)
      expect(user.votes.count).to eq(1)
    end

    scenario 'can cancel out prior vote' do
      within('#question') do
        click_on '⬆️'
        click_on '⬆️'
      end
      expect(Question.last.votes.count).to eq(0)
      expect(User.last.votes.count).to eq(0)
    end

    scenario 'cannot vote on own questions or answers' do
      visit question_path(question)
      expect(page).not_to have_content('⬆️')
    end

    scenario 'cannot downvote' do
      expect(page).not_to have_content('⬇️')
    end

    scenario 'vote changes user score' do
      expect(other_user.score).to eq(0)
      expect(other_question.score).to eq(0)
      within('#question') do
        click_on '⬆️'
      end
      expect(User.last.score).to eq(1)
      expect(Question.last.score).to eq(1)
    end
  end

  context 'power user' do
    before(:each) do
      login_as(user, scope: :user)
      user.update_column(:score, 44)
      visit question_path(other_question)
    end

    scenario 'can downvote' do
      within('#question') do
        click_on '⬇️'
      end
      expect(User.last.score).to eq(-1)
    end

    scenario 'has power user flair' do
      visit question_path(question)
      expect(page).to have_content('power user')
    end
  end

  context 'moderator user' do
    before(:each) do
      login_as(user, scope: :user)
      user.update_column(:score, 54)
      visit question_path(other_question)
    end
    scenario 'can downvote' do
      within('#question') do
        click_on '⬇️'
      end
      expect(User.last.score).to eq(-1)
    end

    scenario 'has moderator flair' do
      visit question_path(question)
      expect(page).to have_content('moderator')
    end
  end
end
