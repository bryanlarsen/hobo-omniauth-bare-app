class Authorization < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    provider :string, :null => false, :index => true
    uid      :string, :null => false, :index => true
    timestamps
  end

  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  # return authorization, creating it if necessary.  creates User if
  # current_user is Guest or nil
  def self.auth(hash, current_user)

    # If we don't find an existing authorization for this provider/uid combination, then
    # we'll assume there's also no matching User, so we'll create a User and an
    # authorization for the new user. 
    unless this = self.find_by_provider_and_uid(hash['provider'], hash['uid'])

      # No existing authorization found for this provider/uid

      # Before assuming we need to create a new user, see if we already have a user
      # with the same name. This accounts for the case where you have an Administrator
      # account in your application, but is no matching authorization 
      # for this provider/uid. The User.name :unique requirement will prevent us from
      # creating another user with the same name (and will cause a "Name already taken") 
      # failure. 
      
      username = hash["user_info"]["name"]
      
      current_user = User.find_by_name(username)
      
      if current_user.nil? || current_user.guest?
        # Did not find an existing user in our application, so create one. 
        
        # Create a new user with the name coming from the provider
        current_user = User::Lifecycle.authorize(current_user, :name => username)
        current_user.save!
      end
      
      # Create a new authorization for the current (or new) user. 
      this = self.new(:uid => hash['uid'], :provider => hash['provider'], :user => current_user)
      this.save!

    end
    this
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
