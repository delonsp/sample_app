require 'spec_helper'


  describe "Static pages" do

    subject { page }

    describe "Home page" do
      before { visit root_path }

      it { should_have_title_and_content('', 'Sample App') }
      # should_have_title_and_content is defined inside /spec/support/utilities.rb
      it { should_not have_title('| Home') }
    end

    describe "Help page" do
      before { visit help_path }
      it { should_have_title_and_content('Help','Help') }
    end

    describe "About page" do
      before { visit about_path }
      it { should_have_title_and_content('About Us','About') }
    end

    describe "Contact page" do
      before { visit contact_path }
      it { should_have_title_and_content('Contact','Contact') }
    end

    it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact Us'))
    click_link "Home"
    visit root_path
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    visit root_path
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

  end

#   describe "Home page" do

#     it "should have the content 'Sample App'" do
#       visit root_path
#       expect(page).to have_content('Sample App')
#     end

#     it "should have the base title" do
#       visit root_path
#       expect(page).to have_title("Ruby on Rails Tutorial Sample App")
#     end

#     it "should not have a custom page title" do
#       visit root_path
#       expect(page).not_to have_title('| Home')
#     end
#   end


  