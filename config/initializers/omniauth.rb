OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], client_options: { authorize_path: '/oauth/authenticate' }
  provider :facebook, FACEBOOK_CONFIG['app_key'], FACEBOOK_CONFIG['secret']
  provider :google_oauth2, GOOGLE_CONFIG['app_key'], GOOGLE_CONFIG['secret'], { access_type: 'online', approval_prompt: '' }
end