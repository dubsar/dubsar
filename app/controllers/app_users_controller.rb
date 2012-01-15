class AppUsersController < ApplicationController
  def new
    @user = AppUser.new
  end
  def create
    @user = AppUser.new(params[:app_user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
end

