class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.order_by_reverse_name
    find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
  end

  def self.shelters_with_applications
    joins(pets: :applications).where(applications: {status: "Pending"}).distinct
  end

  def self.find_name(input)
    Shelter.find_by_sql("SELECT name FROM shelters WHERE id = #{input}").first.name
  end

  def self.find_address(input)
    Shelter.find_by_sql("SELECT address FROM shelters WHERE id = #{input}").first.address
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def average_age
    pets.average(:age).round(1)
  end
end
