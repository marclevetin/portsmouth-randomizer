require 'spec_helper'

feature "pages load up" do
  scenario "the unh group loads" do
    visit '/unh'
    expect(page).to have_content("Portsmouth Randomizer-A-Tron 5000!")
  end

  scenario "the unh1 group loads" do
    visit '/unh1'
  expect(page).to have_content("Portsmouth Randomizer-A-Tron 5000!")
  end

  xscenario "the groups page loads" do
    visit '/unh1/groups/2'
    expect(page).to have_content("Groups of 2")
  end

  xscenario "pictures load on main page" do
    visit '/unh'
    expect(page).to have_css('#pic')
  end
end
