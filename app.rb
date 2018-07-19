require_relative 'lib/townhall_scrapper'
require_relative 'lib/townhall_mailer'
require_relative 'lib/twitter_follow'
require 'pry'

def main
  json_file = {
    ain: 'db/ain_emails.JSON',
    aisne: 'db/aisne_emails.JSON',
    loire: 'db/loire_emails.JSON'
  }
  puts "We are going to collect emails from 3 french departements: "
  puts '- Ain'
  puts '- Loire'
  puts '- Aisne'
  collect_emails_json
  puts "Then we are sending emails to each townhall in these departements"
  puts "to let them know about 'The Hacking Project'"
  send_mails(json_file)
  puts "Finally we are sending sending them tweets, they must know who we are !"
  follow_tweeter(json_file)
end

def collect_emails_json
  urls = {
    ain: 'http://annuaire-des-mairies.com/ain.html',
    loire: 'http://annuaire-des-mairies.com/loire.html',
    aisne: 'http://annuaire-des-mairies.com/aisne.html',
  }
  urls.each do |departement, url|
    puts "Generating JSON for #{departement.to_s.capitalize}"
    TownhallScrapper.new(url, departement.to_s.capitalize).list_from_url.write_json_list("db/#{departement}_emails.JSON")
  end
end

def follow_tweeter(json_file)
  json_file.each do |department, filename|
    puts "Following townhalls in #{department}"
    follow = TwitterFollow.new(filename)
    follow.follow
    follow.update_json
  end
end

def send_mails(json_file)
  json_file.each do |departement, filename|
    puts "Sending mails to every cityhall in #{departement.capitalize}"
    sending = TownhallMailer.new(filename)
    sending.send_email
  end
end

main
