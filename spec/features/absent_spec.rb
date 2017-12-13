require 'spec_helper'

feature "absent students" do
  scenario "absent link appears" do
    visit '/unh'
    expect(page).to have_content("Mark folks absent")
  end

  scenario "clicking absent link brings you to absent page" do
    visit '/unh'
    click_link('Mark folks absent')
    expect(page).to have_content("Mark folks absent")
  end

  scenario "form appears" do
    visit '/unh'
    click_link('Mark folks absent')
    expect(page).to have_content("Adam M")
  end

  scenario "completed form removes people from groups" do
    expect(page).to have_content("expected text")
    expect(page).to_not have_content(expected value)
  end
end
