desc "Create a pseudo-user to which we will attach pulled-in Tweets"
task create_twitter_user: :environment do
  User.where(name: "Twitter", provider: 'system').first || User.create { |user| user.name = 'Twitter'; user.provider = 'system' }
end