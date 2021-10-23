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
end