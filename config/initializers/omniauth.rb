OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_CONFIG['app_key'], TWITTER_CONFIG['secret']
  provider :facebook, FACEBOOK_CONFIG['app_key'], FACEBOOK_CONFIG['secret']
end