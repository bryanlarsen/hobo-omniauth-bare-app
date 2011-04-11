Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, 'REPLACE_WITH_CLIENT_ID', 'REPLACE_WITH_SECRET'
end
