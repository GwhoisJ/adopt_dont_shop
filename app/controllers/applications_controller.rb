class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = Application.search(params[:search])
  end

  def new
  end

  def create
    
    if params[:street_address] != "" && params[:city] != "" && params[:state] != "" && params[:zip_code] != ""
      address = params[:street_address] + ", " + params[:city] + ", " + params[:state] + " " + params[:zip_code]
    else
      address = nil
    end

    application = Application.new({
      name: params[:name],
      address: address,
      status: "In Progress"
      })

    if application.save
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