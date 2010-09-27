require 'logger'
require 'rubygems'
gem 'tweetstream', '~> 1'
require 'tweetstream'
gem 'broach', '~> 0.2'
require 'broach'

config_file = ARGV.first
app_name = "sparkfizzle_#{File.basename(config_file, '.yml')}"

CONFIG = YAML.load(File.read(config_file))
LOG = Logger.new("#{app_name}.log")

Broach.settings = {
  'account' => CONFIG['campfire']['account'],
  'token'   => CONFIG['campfire']['token']
}

tweetstream = TweetStream::Client.new(CONFIG['twitter']['user'], CONFIG['twitter']['password'])
follows = CONFIG['follows']
track_terms = CONFIG['track_terms']

begin

  LOG.info "Monitoring tweets"

  tweetstream.filter(:follow => follows, :track => track_terms) do |status|
    LOG.debug "Found tweet: http://twitter.com/#{status.user.screen_name}/status/#{status.id}"
    Broach.speak(CONFIG['campfire']['room'], "http://twitter.com/#{status.user.screen_name}/status/#{status.id}", :type => :tweet)
  end.on_delete do |status_id, user_id|
    LOG.info "Tweet deleted: #{status_id} by #{user_id}"
  end.on_limit do |skip_count|
    LOG.info "Twitter rate limit, skipped: #{skip_count}"
  end.on_error do |message|
    LOG.error message
  end

rescue JSON::ParserError => ex
  LOG.error ex
rescue TweetStream::ReconnectError => ex
  LOG.error ex
end
