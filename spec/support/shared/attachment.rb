shared_examples_for "Attachmentable" do
  scenario "User adds file when asks", js: true do
    fill_in_text_fields { fill_in_block }

    click_on 'Add file'

    all('input[type="file"]').first.set("#{Rails.root}/spec/rails_helper.rb")
    all('input[type="file"]').last.set("#{Rails.root}/spec/spec_helper.rb")

    click_on "#{button}"

    within "#{selector}" do
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end
end
