require 'spec_helper'

describe UserSignup do
  describe '#sign_up' do
    context 'valid personal info and valid card' do
      let(:charge) { double(:charge, successful?: true) }

      before do
        ActionMailer::Base.deliveries.clear
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up('some stripe token', nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
        UserSignup.new(Fabricate.build(:user, email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe')).sign_up('some stripe token', invitation.token)
        jane = User.find_by(email_address: 'jane@example.com')
        expect(jane.follows?(bob)).to be_truthy
      end

      it "makes the inviter follow the user" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
        UserSignup.new(Fabricate.build(:user, email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe')).sign_up('some stripe token', invitation.token)
        jane = User.find_by(email_address: 'jane@example.com')
        expect(bob.follows?(jane)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
        UserSignup.new(Fabricate.build(:user, email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe')).sign_up('some stripe token', invitation.token)
        jane = User.find_by(email_address: 'jane@example.com')
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user valid inputs" do
        UserSignup.new(Fabricate.build(:user, email_address: 'jane@example.com')).sign_up('some stripe token', nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['jane@example.com'])
      end

      it "sends out email containing the users name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email_address: 'jane@example.com', full_name: 'Jane Doe')).sign_up('some stripe token', nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Jane Doe")
      end
    end

    context "valid personal info and declined card" do
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up('123234', nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      before do
        UserSignup.new(User.new(email_address: 'johndoe@example.com'  )).sign_up('123234', nil)
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "does not send out email with invalid inputs" do
        ActionMailer::Base.deliveries.clear
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
