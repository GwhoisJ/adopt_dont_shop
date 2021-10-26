class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = @application.pets.distinct

    if params[:pet].present?
      if params[:approved] == "true"
        if Pet.find(params[:pet]).approved == nil
          Pet.find(params[:pet]).update(approved: "#{@application.id},")
        else
          new_list = Pet.find(params[:pet]).approved + "#{@application.id},"
          Pet.find(params[:pet]).update(approved: new_list)
        end
      else
        if Pet.find(params[:pet]).denied == nil
          Pet.find(params[:pet]).update(denied: "#{@application.id},")
        else
          new_list = Pet.find(params[:pet]).denied + "#{@application.id},"
          Pet.find(params[:pet]).update(denied: new_list)
        end
      end
    end
  end
end