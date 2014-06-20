require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') } 
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end


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
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should_have_title_and_content("Edit user", "Update your profile") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
    describe "with valid information" do
      
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before { valid_update(user, new_name, new_email) }
      # valid_update is defined inside /spec/support/utilities.rb

      it { should have_title(new_name) }
      it { should have_success_message('') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end