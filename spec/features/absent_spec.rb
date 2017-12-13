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

  scenario "absent folks appear on class page" do
    visit '/unh'
    click_link('Mark folks absent')
    check('Adam M')
    click_on('submit')
    expect(page).to have_content("These folks are absent today: Adam M")
  end

  scenario "already absent folks appear as absent when going to that page" do
    visit '/unh'
    click_link('Mark folks absent')
    check('Adam M')
    click_on('submit')
    click_link('Mark folks absent')
    expect(page).to have_checked_field('Adam M')
  end
end
