class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_password

  def home
  end
  
  protected
  
  def check_password
    redirect_to login_path unless connected?
  end
  
  def connected?
    session[:password] == ENV["PASSWORD"]
  end
  
  def reset_session
    session[:password] = nil
  end
  
end
