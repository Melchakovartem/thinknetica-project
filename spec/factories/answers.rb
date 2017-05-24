FactoryGirl.define do
  factory :answer do
    body { "Body of answer - #{rand(1..1000)}" }
    question { FactoryGirl.create(:question) }
  end
end
