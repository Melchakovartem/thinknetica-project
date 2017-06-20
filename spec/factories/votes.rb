FactoryGirl.define do
  factory :vote do
    votable_id 1
    votable_type "MyString"
    value "Value"
    user { create(:user) }
  end
end
