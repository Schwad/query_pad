require 'rails_helper'
feature 'Questions' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:other_user) { create(:user) }
  let!(:other_question) { create(:question, user: other_user, title: 'Where do I find the nearest food truck?') }

  context 'authorised user' do

    before(:each) do
      login_as(user, :scope => :user)
    end

    scenario 'sees questions when logged in' do
      visit root_path
      expect(page).to have_content('QueryPad Questions Portal')
    end

    scenario 'can view a collection of questions index page' do
      visit questions_path
      expect(page).to have_content('QueryPad Questions Portal')
      expect(page).to have_content(question.title)
    end

    scenario 'can view an existing question' do
      visit questions_path
      click_on(question.title)
      expect(page).to have_content(question.body)
    end

    scenario 'can submit a new question' do
      visit root_path
      click_on 'New Question'
      expect(page).to have_content('The QueryPad community values any enquiries from any of our employees')
      fill_in 'Title', with: 'Where do I file a request for leave?'
      fill_in 'Body', with: 'I have looked everywhere on the company portal and cannot seem to find it anywhere at all.'
      click_on 'Submit'
      expect(page).to have_content('Where do I file a request for leave?')
    end

    scenario 'must include a title on a new question' do
      visit root_path
      click_on 'New Question'
      click_on 'Submit'
      expect(page).to have_content('Title can\'t be blank')
    end

    scenario 'can edit their own question' do
      visit question_path(question)
      click_on 'edit'
      fill_in 'Title', with: 'This question is now edited'
      click_on 'Submit'
      expect(page).to have_content('This question is now edited')
      expect(page).to have_content('Question saved!')
    end

    scenario 'cannot edit someone else\'s question' do
      visit edit_user_question_path(other_user, other_question)
      expect(page).not_to have_content 'Edit your question'
    end

    scenario 'can destroy their own question' do
      visit question_path(question)
      click_on 'delete'
      expect(page).to have_content('Question successfully deleted!')
      expect(Question.count).to eq(1)
    end

    scenario 'cannot destroy someone else\'s question' do
      visit question_path(other_question)
      expect(page).not_to have_content('delete')
    end
  end

  context 'unauthorised user' do

    scenario 'cannot access questions' do
      visit root_path
      visit questions_path
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end

    scenario 'cannot submit questions' do
      visit new_user_question_path(user)
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  end
end
