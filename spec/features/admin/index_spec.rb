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
end