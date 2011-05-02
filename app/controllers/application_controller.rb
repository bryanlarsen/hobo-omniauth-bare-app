class ApplicationController < ActionController::Base

  protect_from_forgery       
  
  # This before_filter prevents access to all pages in your application, except
  # those served up by the actions in the :except array. In this example, we have
  # excepted the ":index" action to allow a user to access the
  # front_controller#index page and not be logged in. On our front#index page, 
  # we have also included the <login-form> so users need to be able to access
  # that page without being logged in. 
                                       
  # When defining this before_filter, you MUST pass it a named method (as below,
  # where it is passed the method named 'my_login_required'). If you do not
  # pass a method name, the before_filter will be anonymous, and will NOT be
  # found by overrides (or 'skip_before_filter' directives) in other controllers. 
  # This is incorrect:
  # before_filter, :except => [:login, ... etc.... ] do my_login_required end
  # because it creates an anonymous filter. 
    
  before_filter :my_login_required, :except => [:index, :login, :signup, :activate,
         :do_activate, :do_signup, :forgot_password, :reset_password,
         :do_reset_password]

  # We provide our own method to call the Hobo helper here, so we can check the 
  # User count. 
  def my_login_required
   login_required unless User.count==0
  end
  
end
