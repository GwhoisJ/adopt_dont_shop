class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def new
  end

  def create
    
    if params[:street_address] != "" && params[:city] != "" && params[:state] != "" && params[:zip_code] != ""
      address = params[:street_address] + ", " + params[:city] + ", " + params[:state] + " " + params[:zip_code]
    else
      address = nil
    end

    if params[:name] != "" && address != nil
      application = Application.new({
        name: params[:name],
        address: address,
        status: "In Progress"
        })
    else
      application = Application.new({ name: nil })
    end
    # binding.pry
    
    if application.status != nil
      application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash[:alert] = "Error: Fields must be filled out"
    end
  end

  # private

  # def application_params
  #   # address = params[:street_address] + " ," + params[:city] + " ," + params[:state] + " " + params[:zip_code]
  #   params.permit(:id, :name, :street_address, :city, :state, :zip_code, :description)
  # end
end