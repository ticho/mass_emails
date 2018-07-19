require_relative 'lib/townhall_scrapper'
require 'pry'

def main
  puts "We are going to collect emails from 3 french departements: "
  puts '- Ain'
  puts '- Loire'
  puts '- Aisne'
  collect_emails_json
  puts "Then we are sending emails to each townhall in these departements"
  puts "to let them know about 'The Hacking Project'"
  # send_mails
  puts "Finally we are sending sending them tweets, they must know who we are !"
  # follow_tweet
end

def collect_emails_json
  urls = {
    ain: 'http://annuaire-des-mairies.com/ain.html',
    loire: 'http://annuaire-des-mairies.com/loire.html',
    aisne: 'http://annuaire-des-mairies.com/aisne.html',
  }
  urls.each do |departement, url|
    puts "Generating JSON for #{departement.to_s.capitalize}"
    TownhallScrapper.new(url).list_from_url.write_json_list("db/#{departement}_emails.JSON")
  end
end

def send_mails
  json_file = [
    'ain_emails.json',
    'aisne_emails.json',
    'loire_emails.json'
  ]
  json_file.each do |filename|
    follow = TwitterFollow.new(filename)
    follow.follow
  end
end

main
