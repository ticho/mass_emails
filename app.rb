require_relative 'lib/townhall_scrapper'
require 'pry'

def main
  puts "We are going to collect emails from 3 french departements: "
  puts '- Finistere'
  puts '- Loire'
  puts '- Aisne'
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

collect_emails_json
# loire = TownhallScrapper.new('http://annuaire-des-mairies.com/loire.html')
      # .list_from_url.write_json_list("db/loire_emails_20.JSON")
# binding.pry
