require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should_have_title_and_content('Sign up', 'Sign up') }
    # should_have_title_and_content is defined inside /spec/support/utilities.rb
  end

  describe "profile page" do
	  let(:user) { FactoryGirl.create(:user) } 
	  before { visit user_path(user) }

	  it { should_have_title_and_content(user.name, user.name) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "after submission" do
        before { click_button submit }

        it { should_have_title_and_content('Sign up', 'error') }
    end

    describe "with valid information" do
      before { valid_signup }
      # valid_signup is a method in spec/support/utilities.rb

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_success_message('Welcome') }
        # have_success_message is defined inside /spec/support/utilities.rb
      end
    end
  end
end