require 'digest'

class SessionsController < ApplicationController
  skip_before_filter :check_password

  def new
    redirect_to shortened_url_index_path if connected?
  end

  def create
    session[:password] = Digest::SHA512.hexdigest(params[:password])
    if connected?
      flash[:notice] = "Okay! C'est toi le boss."
      redirect_to shortened_url_index_path
    else
      render :new
    end
  end
  
  def destroy
    reset_session
    flash[:notice] = "Il est mort !"
    redirect_to login_path
  end
end
