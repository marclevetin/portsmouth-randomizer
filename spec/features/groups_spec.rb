require 'spec_helper'

feature "groups" do
  scenario "groups page loads with appropriate count of students (2)" do
    visit '/unh/groups/2'
    expect(page).to have_content("Groups of 2")
  end

  scenario "groups page loads with appropriate count of students (3)" do
    visit '/unh/groups/3'
    expect(page).to have_content("Groups of 3")
  end

  xscenario "back button returns to main page" do
    visit 'unh'
    fill_in('groups', :with => '3')
    click_button('submit')
    click_button('< Back')
    save_and_open_page
    expect(page).to have_content("will answer the question!")
  end

  scenario "generate another group button works" do
    visit '/unh/groups/3'
    click_button('Gimme another group!')
    expect(page).to have_content("Groups of 3")
    expect(page).to have_content("< Back")
  end
end
