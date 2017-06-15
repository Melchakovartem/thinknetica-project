FactoryGirl.define do
  factory :attachment do
    attachmentable_id 1
    attachmentable_type "MyString"
    file { File.open("#{Rails.root}/spec/rails_helper.rb") }
  end
end
