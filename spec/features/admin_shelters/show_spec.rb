require 'rails_helper'

RSpec.describe 'admin shelters show page' do
  before :each do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '123 example st.')
  end

  it 'lists the shelter info' do
    visit "/admin/shelters/#{@shelter.id}"

    expect(page).to have_content(@shelter.name)
    expect(page).to have_content(@shelter.address)
  end
end