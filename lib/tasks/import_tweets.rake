desc "Search Twitter for #rootstrikers and import links/contents from tweets"
task import_tweets: :environment do
  Twitter::Fetcher.run
end
