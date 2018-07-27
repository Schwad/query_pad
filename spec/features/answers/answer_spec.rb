require 'rails_helper'
feature 'Answers' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question)}
  let!(:other_user) { create(:user) }
  let!(:other_question) { create(:question, user: other_user, title: 'Where do I find the nearest food truck?') }
  let!(:other_answer) { create(:answer, user: other_user, question: other_question)}

  context 'authorised user' do

    before(:each) do
      login_as(user, :scope => :user)
    end

    scenario 'can view an existing answer' do
      visit questions_path
      click_on(question.title)
      expect(page).to have_content(answer.body)
    end

    scenario 'can submit a new answer' do
      visit question_path(question)
      click_on 'Add Answer'
      fill_in 'Body', with: 'It is what it is.'
      click_on 'Submit'
      expect(page).to have_content('It is what it is')
      expect(question.answers.count).to eq(2)
    end

    scenario 'must include a body on a new answer' do
      visit new_user_answer_path(user, question_id: @question)
      click_on 'Submit'
      expect(page).to have_content('Body can\'t be blank')
    end

    scenario 'can edit their own answer' do
      visit question_path(question)
      click_on 'edit answer'
      fill_in 'Body', with: 'I sure did not expect this.'
      click_on 'Submit'
      expect(page).to have_content('I sure did not expect this.')
      expect(page).to have_content('Answer saved!')
    end

    scenario 'cannot edit someone else\'s answer' do
      visit edit_user_answer_path(other_user, other_answer)
      expect(page).not_to have_content 'Edit your question'
    end

    scenario 'can destroy their own question' do
      visit question_path(question)
      click_on 'delete answer'
      expect(page).to have_content('Answer successfully deleted!')
      expect(question.answers.count).to eq(0)
    end

    scenario 'cannot destroy someont else\'s answer' do
      visit question_path(other_question)
      expect(page).not_to have_content('delete answer')
    end
  end

  context 'unauthorised user' do
    scenario 'cannot submit answers' do
      visit new_user_answer_path(user.id, question_id: question.id)
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  end
end
