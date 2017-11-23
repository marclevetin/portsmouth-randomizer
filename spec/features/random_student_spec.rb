require 'spec_helper'

feature "random student selection" do
  scenario "the page loads" do
    visit 'unh'
    expect(page).to have_content("expected text")
    expect(page).to_not have_content(expected value)
  end

  scenario "a random student is selected" do
    visit 'unh'
    expect(page).to have_content("expected text")
    expect(page).to_not have_content(expected value)
  end

  scenario "random student is added to the 'picked' student list" do
    visit 'unh'
    expect(page).to have_content("expected text")
    expect(page).to_not have_content(expected value)
  end

  scenario "random student will not be picked again until reset" do
    visit 'unh'
    expect(page).to have_content("expected text")
    expect(page).to_not have_content(expected value)
  end

  scenario "full list of students is restored when everyone has been picked" do
    visit 'unh'
    expect(page).to have_content("expected text")
    expect(page).to_not have_content(expected value)
  end

  scenario "the same student will not be picked twice in a row" do
    visit 'unh'
    expect(page).to have_content("expected text")
    expect(page).to_not have_content(expected value)
  end
end
