class FrontController < ApplicationController

  hobo_controller      
  
  # Require the user to be logged in for every other action on this controller
  # except :index. 
  before_filter :except => [:index] do
    my_login_required
  end
  
  def index; end

  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end

end
