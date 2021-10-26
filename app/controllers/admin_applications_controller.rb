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

    if application_approved
      @application.update(status: "Approved")
    elsif application_approved == false
      @application.update(status: "Rejected")
    end
  end

  def application_approved
    if @pets.any? {|pet| pet.denied_applications(@application.id)}
      false
    elsif @pets.all {|pet| pet.approved_applications(@application.id)}
      true
    else
      nil
    end
  end
end