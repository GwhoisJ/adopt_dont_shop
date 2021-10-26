require 'rails_helper'

RSpec.describe 'Admin Shelters index' do
  it 'lists all the shelters in reverse order' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    visit '/admin/shelters'

    within("#shelter-0") do
      expect(page).to have_content(shelter_2.name)
    end
    
    within("#shelter-1") do
      expect(page).to have_content(shelter_3.name)
    end
    
    within("#shelter-2") do
      expect(page).to have_content(shelter_1.name)
    end
  end

  it 'lists all shelters with pending applications' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    pet_3 = shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    pet_4 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
  
    application_1 = Application.create(name: 'Greg',
      address: '123 streetname',
      description: 'I good pet owner',
      status: 'Pending')
    application_2 = Application.create(name: 'Bob',
                                      address: '123 streetname',
                                      status: 'In Progress')

    ApplicationPet.create(application: application_1, pet: pet_2)
    ApplicationPet.create(application: application_2, pet: pet_3)

    visit '/admin/shelters'

    within('#pending') do
      expect(page).to have_content(shelter_1.name)
      expect(page).to_not have_content(shelter_2.name)
      expect(page).to_not have_content(shelter_3.name)
    end
  end
end