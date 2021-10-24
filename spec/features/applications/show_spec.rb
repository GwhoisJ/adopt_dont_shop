require 'rails_helper'

RSpec.describe 'show page for applications' do
  before(:each) do
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

  it 'shows the name of the applicant' do
    visit "/applications/#{@application.id}"

    expect(page).to have_content(@application.name)
  end

  it 'shows the address of the applicant' do
    visit "/applications/#{@application.id}"

    expect(page).to have_content(@application.address)
  end

  it 'lists partial matches as search results' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)

    visit "/applications/#{@application.id}"

    fill_in 'Add a Pet to this Application', with: "Ba"
    click_on("Submit")

    expect(page).to have_content(pet_1.name)
    expect(page).to have_content(pet_2.name)
    expect(page).to_not have_content(pet_3.name)
  end

  it 'has an adopt a pet option' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
    pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)

    visit "/applications/#{@application.id}"

    fill_in 'Add a Pet to this Application', with: "Ba"
    click_on("Submit")

    within("#pet-0") do
      expect(page).to have_button("Adopt this Pet")
      click_on("Adopt this Pet")
    end

    expect(current_path).to eq("/applications/#{@application.id}")

    expect(@application.pets).to include(pet_1)
  end

  it 'can be submitted' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)

    visit "/applications/#{@application.id}"

    fill_in 'Add a Pet to this Application', with: "Ba"
    click_on("Submit")

    click_on("Adopt this Pet")

    fill_in 'description', with: 'example'
    click_on("Submit Application")

    expect(current_path).to eq("/applications/#{@application.id}")
    expect(page).to have_content("example")
    expect(page).to have_content("Pending")

    expect(page).to_not have_content("In Progress")
    expect(page).to_not have_content("Add a Pet to this Application")
    expect(page).to_not have_content("Submit Your Application")
    expect(page).to_not have_button('Submit')
  end
end