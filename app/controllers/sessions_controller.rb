class SessionsController < HomeController
  # should be enforced
  #force_ssl

  def new
    puts "session#new"
  end

  def create
    user = login params[:email], params[:password], params[:remember_me]
    if user
      redirect_back_or_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged in!"
  end
end

