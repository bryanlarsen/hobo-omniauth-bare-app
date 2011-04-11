class AddAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :authorizations do |t|
      t.string   :provider, :null => false
      t.string   :uid, :null => false
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :authorizations, [:provider]
    add_index :authorizations, [:uid]
    add_index :authorizations, [:user_id]
  end

  def self.down
    drop_table :authorizations
  end
end
