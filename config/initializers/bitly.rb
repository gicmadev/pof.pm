Bitly.use_api_version_3

Bitly.configure do |config|
  config.api_version = 3
  Rails.logger.debug(ENV["BITLY_TOKEN"])
  config.access_token = ENV["BITLY_TOKEN"]
end
