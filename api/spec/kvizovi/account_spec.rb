require "spec_helper"
require "kvizovi/account"
require "timecop"

RSpec.describe Kvizovi::Account do
  subject { Kvizovi::Account.new(@user) }
  let(:attributes) { attributes_for(:janko) }

  before do
    allow(Kvizovi).to receive(:mailer).and_return(spy)
    allow(Kvizovi).to receive(:generate_token).and_return("token")
    allow(Kvizovi).to receive(:hash) { |string| string.to_s.reverse }
    allow(Kvizovi).to receive(:password) { |string| string.to_s.reverse }
  end

  def register(additional_attributes = {})
    Kvizovi::Account.register!(attributes.merge(additional_attributes))
  end

  describe ".register!" do
    it "controls mass assignment" do
      expect { Kvizovi::Account.register!(created_at: Time.now) }
        .to raise_error(Sequel::Error)
    end

    it "encrypts the password" do
      user = Kvizovi::Account.register!(attributes)

      expect(user.encrypted_password).to be_a_nonempty(String)
      expect(user.encrypted_password).not_to eq user.password
    end

    it "assigns the confirmation token" do
      user = Kvizovi::Account.register!(attributes)

      expect(user.confirmation_token).to be_a_nonempty(String)
    end

    it "assigns the authentication token" do
      user = Kvizovi::Account.register!(attributes)

      expect(user.token).to be_a_nonempty(String)
    end

    it "saves the user" do
      user = Kvizovi::Account.register!(attributes)

      expect(user.new?).to eq false
    end

    it "sends the confirmation email" do
      user = Kvizovi::Account.register!(attributes)

      expect(Kvizovi.mailer).to have_received(:registration_confirmation)
    end
  end

  describe ".authenticate" do
    before { @user = register }

    it "returns the authenticated user" do
      credentials = {email: @user.email, password: @user.password}

      user = Kvizovi::Account.authenticate(credentials)

      expect(user).to be_a(Kvizovi::Models::User)
    end

    it "returns errors if password was invalid" do
      credentials = {email: @user.email, password: "incorrect password"}

      expect { Kvizovi::Account.authenticate(credentials) }
        .to raise_error(Kvizovi::Error)
    end

    it "returns errors if email was invalid" do
      credentials = {email: "incorrect@email.com", password: @user.password}

      expect { Kvizovi::Account.authenticate(credentials) }
        .to raise_error(Kvizovi::Error)
    end

    it "raises an error if account has expired" do
      credentials = {email: @user.email, password: @user.password}

      Timecop.travel(4*24*60*60) do
        expect { Kvizovi::Account.authenticate(credentials) }
          .to raise_error(Kvizovi::Error)
      end
    end
  end

  describe ".confirm!" do
    before { @user = register }

    it "sets the time of the confirmation" do
      user = Kvizovi::Account.confirm!(@user.confirmation_token)

      expect(user.confirmed_at).to be_a(Time)
    end

    it "deassigns the confirmation token" do
      user = Kvizovi::Account.confirm!(@user.confirmation_token)

      expect(user.confirmation_token).to eq nil
    end
  end

  describe ".reset_password!" do
    before { @user = register }

    it "assigns the password reset token" do
      user = Kvizovi::Account.reset_password!(email: @user.email)

      expect(user.password_reset_token).to be_a_nonempty(String)
    end

    it "sends the password reset instructions email" do
      user = Kvizovi::Account.reset_password!(email: @user.email)

      expect(Kvizovi.mailer).to have_received(:password_reset_instructions)
    end

    it "raises error when email is nonexisting" do
      expect { described_class.reset_password!(email: "nonexisting@email.com") }
        .to raise_error(Kvizovi::Error)
    end
  end

  describe ".set_password!" do
    before { @user = register }
    before { @user = Kvizovi::Account.reset_password!(email: @user.email) }
    let(:token) { @user.password_reset_token }

    it "controls mass assignment" do
      expect { Kvizovi::Account.set_password!(token, created_at: nil) }
        .to raise_error(Sequel::Error)
    end

    it "encrypts the password" do
      old_password = @user.encrypted_password

      user = Kvizovi::Account.set_password!(token, password: "new secret")

      expect(user.encrypted_password).to be_a_nonempty(String)
      expect(user.encrypted_password).not_to eq old_password
    end

    it "deassigns the password reset token" do
      user = Kvizovi::Account.set_password!(token, password: "new secret")

      expect(user.password_reset_token).to eq nil
    end

    it "saves the user" do
      old_password = @user.encrypted_password

      user = Kvizovi::Account.set_password!(token, password: "new secret")

      expect(user.encrypted_password).not_to eq old_password
    end
  end

  describe "#update!" do
    before { @user = register }
    before { @user.password = nil }

    it "controls mass assignment" do
      expect { subject.update!(created_at: nil) }
        .to raise_error(Sequel::Error)
    end

    it "requires old password for changing to new password" do
      expect { subject.update!(password: "new secret") }
        .to raise_error(ArgumentError, /doesn't match/)
    end

    it "encrypts the password if present" do
      old_password = @user.encrypted_password

      subject.update!({})

      expect(@user.encrypted_password).to eq old_password

      subject.update!(password: "new secret", old_password: attributes_for(:janko)[:password])

      expect(@user.encrypted_password).to be_a_nonempty(String)
      expect(@user.encrypted_password).not_to eq old_password
    end
  end

  describe "#destroy!" do
    before { @user = register }

    it "destroys the user" do
      subject.destroy!

      expect(@user).not_to exist
    end
  end
end
