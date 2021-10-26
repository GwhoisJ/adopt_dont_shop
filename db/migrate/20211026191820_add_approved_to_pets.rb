class AddApprovedToPets < ActiveRecord::Migration[5.2]
  def change
    add_column :pets, :approved, :string
  end
end
