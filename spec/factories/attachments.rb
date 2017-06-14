FactoryGirl.define do
  factory :attachment do
    attachmentable_id 1
    attachmentable_type "MyString"
    file "MyString"
  end
end
