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
    debugger
    unless this = self.find_by_provider_and_uid(hash['provider'], hash['uid'])
      if current_user.nil? || current_user.guest?
        current_user = User::Lifecycle.authorize(current_user, :name => hash["user_info"]["name"])
        current_user.save!
      end
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
