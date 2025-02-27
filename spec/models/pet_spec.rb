require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it {should have_many :application_pets}
    it {should have_many(:applications).through(:application_pets)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true, denied: "1")
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false, approved: "1")
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end

    describe '#pets_with_pending_applicaions_by_shelter' do
      it 'returns pets that have pending applications for a given shelter' do
        application = Application.create(name: 'Greg',
          address: '123 streetname',
          description: 'I good pet owner',
          status: 'Pending')

        ApplicationPet.create(application: application, pet: @pet_1)
        ApplicationPet.create(application: application, pet: @pet_2)

        expect(Pet.pets_with_pending_applications).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '#approved_applications' do
      it 'returns true if approved' do
        expect(@pet_3.approved_applications(1)).to be true
      end
    end

    describe '#denied_applications' do
      it 'returns true if denied' do
        expect(@pet_1.denied_applications(1)).to be true
      end
    end
  end
end
