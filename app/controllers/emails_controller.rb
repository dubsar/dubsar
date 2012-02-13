class EmailsController < ApplicationController
  def index
    @emails = Email.where("email like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @emails }
    end
  end
end

