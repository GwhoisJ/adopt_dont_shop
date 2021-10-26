require 'rails_helper'

RSpec.describe 'admin application show page' do
  before :each do
    @application = Application.create(name: 'Greg',
      address: '123 streetname',
      description: 'I good pet owner',
      status: 'In Progress')

    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    @pet_1 = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
    @pet_2 = Pet.create(name: 'Bob', age: 5, breed: 'Big Boy', adoptable: true, shelter_id: @shelter.id)

    ApplicationPet.create(application: @application, pet: @pet_1)
    ApplicationPet.create(application: @application, pet: @pet_2)
  end

  it 'can approve a pet' do
    visit "/admin/applications/#{@application.id}"

    within('#pet-0') do
      click_on("Approve this pet")
    end

    within('#pet-0') do
      expect(page).to_not have_button
      expect(page).to have_content("Approved!")
    end
  end
  
  it 'can reject a pet' do
    visit "/admin/applications/#{@application.id}"

    within('#pet-0') do
      click_on("Reject this pet")
    end

    within('#pet-0') do
      expect(page).to_not have_button
      expect(page).to have_content("Rejected.")
    end
  end
end