FactoryGirl.define do
  factory :answer do
    body "MyString"
    question { FactoryGirl.create(:question) }
  end
end
