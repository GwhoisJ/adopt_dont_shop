class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_reverse_name
    @pendings = Shelter.shelters_with_applications
  end

  def show
    @shelter = Shelter.find(params[:id])
    @name = Shelter.find_name(params[:id])
    @address = Shelter.find_address(params[:id])
  end
end