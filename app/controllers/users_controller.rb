class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all, :except => [ :index, :new, :create ]
  index_action :omniauth_callback

  def create
    hobo_create do
      if valid?
        self.current_user = this
        flash[:notice] = t("hobo.messages.you_are_site_admin", :default=>"You are now the site administrator")
        redirect_to home_page
      end
    end
  end

  def omniauth_callback
    if self.this=Authorization.auth(request.env["omniauth.auth"], current_user)
      sign_user_in(self.this.user)
    else
      raise request.env["omniauth.auth"].to_yaml
    end
  end

end
