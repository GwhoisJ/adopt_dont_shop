class AdminController < ApplicationController
  def index
    @shelters = Shelter.order_by_reverse_name
    @pendings = Shelter.shelters_with_applications
  end
end