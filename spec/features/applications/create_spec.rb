require 'rails_helper'

RSpec.describe 'new application page' do
  it 'has the right form' do
    visit '/applications/new'

    expect(page).to have_content('Name:')
    expect(page).to have_content('Street Address:')
    expect(page).to have_content('City:')
    expect(page).to have_content('State:')
    expect(page).to have_content('Zip Code:')

    expect(page).to have_button
  end

  it 'must have fields filled out' do
    visit '/applications/new'

    click_button

    expect(current_path).to eq('/applications/new')
    expect(page).to have_content('Fields must be filled out')
  end
end