require 'rails_helper'
feature 'Searches' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:other_question) { create(:question, user: user, title: 'Where do I find the nearest food truck?', body: 'I just want some tacos or burritos') }

  context 'by title' do
    before(:each) do
      login_as(user, :scope => :user)
    end
    scenario 'search matching value' do
      visit root_path
      fill_in 'q', with: 'Where do I find the nearest food truck?'
      click_on 'Search'
      expect(page).to have_content('Where do I find the nearest food truck?')
      expect(page).not_to have_content('What is the meaning of development?')
    end
  end

  context 'by body' do
    before(:each) do
      login_as(user, :scope => :user)
    end
    scenario 'search matching value' do
      visit root_path
      fill_in 'q', with: 'I just want some tacos or burritos'
      click_on 'Search'
      expect(page).to have_content('Where do I find the nearest food truck?')
      expect(page).not_to have_content('What is the meaning of development?')
    end
  end
end
