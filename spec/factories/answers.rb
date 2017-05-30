FactoryGirl.define do
  factory :answer do
    body { "Body of answer - #{rand(1..1000)}" }
    question { create(:question) }
    user { create(:user) }
  end
end
