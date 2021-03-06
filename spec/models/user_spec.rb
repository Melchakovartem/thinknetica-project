require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many :comments }
  it { should have_many :subscriptions }

  describe ".find_for_ouath" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456") }

    context "user already has authorization" do
      it "returns the user" do
        user.authorizations.create(provider: "facebook", uid: "123456")
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user has not authorization" do
      context "user already exists" do
        let!(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: user.email }) }

        it "doesn't create new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "creates authoriztion for user" do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "creates authoriztion with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns the user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context "user doesn't exist" do
        let!(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456", info: { email: "new@user.com" }) }

        it "creates new user" do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it "returns new user" do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it "fills user email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it "creates authorization for user" do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context "email is empty" do
        let!(:auth) { OmniAuth::AuthHash.new(provider: "vk", uid: "123456", info: { }) }

        it "doesn't create new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "returns nil" do
          user = User.find_for_oauth(auth)
          expect(nil).to be_nil
        end

        it "doesn't create exception" do
          expect { User.find_for_oauth(auth) }.to_not raise_exception
        end
      end
    end
  end

  describe ".subscribed" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    context "if subscription exists" do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it "returns subscription" do
        expect(user.subscribed(question)).to eq subscription
      end
    end

    context "if subscription doesn't exist" do
      it "returns subscription" do
        expect(user.subscribed(question)).to be_nil
      end
    end
  end

  describe ".subscribed?" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    context "if subscription exists" do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it "returns subscription" do
        expect(user.subscribed?(question)).to be_truthy
      end
    end

    context "if subscription doesn't exist" do
      it "returns subscription" do
        expect(user.subscribed(question)).to be_falsey
      end
    end
  end
end
