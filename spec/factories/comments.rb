FactoryGirl.define do
  factory :comment do
    body { "Body of comment - #{rand(1..1000)}" }
  end
end
