require 'twitter'
require "dotenv/load"
require_relative 'lib/townhall_scrapper'

class TwitterFollow
  def initialize(json_file = '')
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_KEY_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
    @json_file = "db/loire_emails.JSON"
    @city_hash = TownhallScrapper.new.read_json_from_db(@json_file)
  end


  #puts city_name_array

  def follow
    @city_hash.each do |city|
      handle = @client.user_search(city["name"])
      begin
        @client.follow!(handle[0])
        city["handle"] = "@" + handle[0].screen_name
        puts "Followed #{city["handle"]}"
      rescue StandardError => e
        puts "Error: #{e.message}"
      end
    end
  end
end

#array = recuperer le nom dans le tableau db/Dep.json each do |variable|



TwitterFollow.new().follow

#city_hash =[[city_hash],[handle]
#rajouter le follow_all_cities dans city_hash
#nom : paris : mail paris twiter : twitter paris
