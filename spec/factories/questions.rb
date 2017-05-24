FactoryGirl.define do
  sequence :title do |n|
    "Title of question - #{n}"
  end

  sequence :body do |n|
    "Body of question - #{n}"
  end

  factory :question do
    title
    body
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
