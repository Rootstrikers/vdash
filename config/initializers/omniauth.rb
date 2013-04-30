OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], client_options: { authorize_path: '/oauth/authenticate' }
  provider :facebook, ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_API_SECRET']
  provider :google_oauth2,  ENV['GOOGLE_API_KEY'], ENV['GOOGLE_API_SECRET'], { access_type: 'online', approval_prompt: '' }
end