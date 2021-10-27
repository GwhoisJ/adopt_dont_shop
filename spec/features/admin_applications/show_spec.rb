require 'rails_helper'

RSpec.describe 'admin application show page' do
  before :each do
    @application = Application.create(name: 'Greg',
      address: '123 streetname',
      description: 'I good pet owner',
      status: 'Pending')

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
      expect(page).to_not have_button("Approve this pet")
      expect(page).to_not have_button("Reject this pet")
      expect(page).to have_content("Approved!")
    end
  end
  
  it 'can reject a pet' do
    visit "/admin/applications/#{@application.id}"
    
    within('#pet-0') do
      click_on("Reject this pet")
    end

    within('#pet-0') do
      expect(page).to_not have_button("Approve this pet")
      expect(page).to_not have_button("Reject this pet")
      expect(page).to have_content("Rejected.")
    end
  end

  it 'can approve an application' do
    visit "/admin/applications/#{@application.id}"

    within('#pet-0') do
      click_on("Approve this pet")
    end

    within('#pet-1') do
      click_on("Approve this pet")
    end

    within('#status') do
      expect(page).to have_content("Approved")
    end
  end

  it 'makes aproved pets not adoptable' do
    visit "/admin/applications/#{@application.id}"

    within('#pet-0') do
      click_on("Approve this pet")
    end

    within('#pet-1') do
      click_on("Approve this pet")
    end
    
    visit "/pets/#{@pet_1.id}"

    expect(page).to have_content("false")
    
    visit "/pets/#{@pet_2.id}"

    expect(page).to have_content("false")
  end

  it 'pets are only adoptable if not on an approved application' do
    application_2 = Application.create!(name: 'Bob', address: "a", status: "Pending")

    ApplicationPet.create!(application: application_2, pet: @pet_1)
    
    visit "/admin/applications/#{@application.id}"

    within('#pet-0') do
      click_on("Approve this pet")
    end

    within('#pet-1') do
      click_on("Approve this pet")
    end

    visit "/admin/applications/#{application_2.id}"

    within('#pet-0') do
      expect(page).to have_content("This pet has been approved for adoption.")
      expect(page).to have_button("Reject this pet")

      expect(page).to_not have_button("Approve this pet")
    end
  end
end