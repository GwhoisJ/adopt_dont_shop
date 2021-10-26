class AddDeniedToPets < ActiveRecord::Migration[5.2]
  def change
    add_column :pets, :denied, :string
  end
end
