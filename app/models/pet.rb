class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def approved_applications(input)
    input = input.to_s
    if approved != nil
      approved.include?(input)
    else
      false
    end
  end

  def denied_applications(input)
    input = input.to_s

    if denied != nil
      denied.include?(input)
    else
      false
    end
  end

  def self.pets_with_pending_applications
    joins(:applications).where(applications: {status: "Pending"})
  end
end
