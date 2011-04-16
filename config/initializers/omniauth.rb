Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, 'REPLACE_WITH_CONSUMER_KEY', 'REPLACE_WITH_CONSUMER_SECRET'
end
