require 'rubygems'
require 'logger'
require 'tweetstream'
require 'broach'

config_file = ARGV.first
app_name = "sparkfizzle_#{File.basename(config_file, '.yml')}"

CONFIG = YAML.load(File.read(config_file))
LOG = Logger.new("#{app_name}.log")

Broach.settings = {
  'account' => CONFIG['campfire']['account'],
  'token'   => CONFIG['campfire']['token']
}

begin

  LOG.info "Monitoring tweets"

  TweetStream::Daemon.new(
    CONFIG['twitter']['user'],
    CONFIG['twitter']['password'],
    app_name
  ).filter(:follow => CONFIG['follows'], :track => CONFIG['track_terms']) do |status|
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
