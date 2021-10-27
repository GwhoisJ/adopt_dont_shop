require 'rails_helper'

RSpec.describe 'admin shelters show page' do
  before :each do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9, address: '123 example st.')
    
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
  end

  it 'lists the shelter info' do
    visit "/admin/shelters/#{@shelter.id}"

    expect(page).to have_content(@shelter.name)
    expect(page).to have_content(@shelter.address)
  end

  it 'lists the average age of the pets' do
    visit "/admin/shelters/#{@shelter.id}"

    expect(page).to have_content('Average age of pets: 2')
  end

  it 'lists the number of adoptable pets' do
    visit "/admin/shelters/#{@shelter.id}"

    expect(page).to have_content('Number of adoptable pets: 2')
  end

  it 'lists the number of adopted pets' do
    visit "/admin/shelters/#{@shelter.id}"

    expect(page).to have_content('Number of adopted pets: 0')
  end
end