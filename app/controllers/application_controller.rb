class ApplicationController < ActionController::Base
  
  before_action :set_date_loaded
  before_action :authorize
  private
    def set_date_loaded
       @date_loaded = Time.now
    end
  
  protected
 
    def authorize
      unless User.find_by(id: session[:user_id], name: session[:user_name])
        redirect_to login_url, notice: "Please log in"
      end
    end
    def authorize_admin
      unless User.find_by(id: session[:user_id], role: "admin")
        redirect_to login_url, notice: "Please log in as admin", alert: "Login as admin! You do not have access!"
      end
    end
  
 protected
  def uncaught_exception_rescue(exception)
    render(:partial => 'errors/not_found', :status => :not_found)
  end
    def handle_unverified_request
    flash[:error] = 'Kindly retry.'
    redirect_to login_url
    end
end
