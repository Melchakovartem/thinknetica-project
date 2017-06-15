require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answer', js: true do
    fill_in 'Body', with: 'Body of answer'

    click_on 'Add file'

    all('input[type="file"]').first.set("#{Rails.root}/spec/rails_helper.rb")
    all('input[type="file"]').last.set("#{Rails.root}/spec/spec_helper.rb")

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link "rails_helper.rb", href: '/uploads/attachment/file/1/rails_helper.rb'
      expect(page).to have_link "spec_helper.rb", href: '/uploads/attachment/file/2/spec_helper.rb'
    end
  end
end
