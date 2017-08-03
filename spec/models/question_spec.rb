require "rails_helper"

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers) }
  it { should have_many :attachments }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many :subscriptions }

  it { should belong_to(:user) }

  describe ".subscribe" do
    it "subscribes after creating question" do
      question = build(:question)
      expect(question).to receive(:subscribe)
      question.save
    end
  end
end
