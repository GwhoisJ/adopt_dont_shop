class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def new
    @application = Application.find(params[:id])
  end

  def create
    address = params[:street_address] + ", " + params[:city] + ", " + params[:state] + " " + params[:zip_code]

    application = Application.new({
       name: params[:name],
       address: address,
       description: params[:description],
       status: "In Progress"
       })
    
    application.save

    redirect_to "/applications/#{application.id}"
  end

  # private

  # def application_params
  #   # address = params[:street_address] + " ," + params[:city] + " ," + params[:state] + " " + params[:zip_code]
  #   params.permit(:id, :name, :street_address, :city, :state, :zip_code, :description)
  # end
end