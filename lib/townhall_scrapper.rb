# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'

class TownhallScrapper
  def initialize(url = '', departement = '')
    @url = if url == ''
             'http://annuaire-des-mairies.com/val-d-oise.html'
           else
             url
           end
    @list = []
    @departement = departement
  end

  def list_from_url
    @list = get_all_the_urls_townhalls(@url)
    @list.each do |city|
      city["department"] = @departement
    end
    self
  end

  def write_json_list(filename = 'db/emails.JSON')
    Dir.mkdir 'db' unless Dir.exist? 'db'
    json_list = @list.to_json
    f = open(filename, 'w')
    f.write(json_list)
    f.close
  end

  def read_json_from_db(filename = 'db/emails.JSON')
    f = open(filename, 'r')
    list = ''
    while (line = f.gets)
      list += line
    end
    f.close
    @list = JSON.parse(list)
  end

  def data_to_csv(data, filename = 'db/emails.csv')
    Dir.mkdir 'db' unless Dir.exist? 'db'
    file = open(filename, 'w')
    file.write("\"name\",\"email\"\n")
    data.each do |line|
      file.write("\"#{line['name']}\",\"#{line['email']}\"\n")
    end
    file.close
  end

  private

  def get_the_email_of_a_townhal_from_its_webpage(url)
    page = Nokogiri::HTML(URI.open(url))
    page.css('td').each do |str|
      begin
        if str.text.chomp.match?(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i)
          return str.text
        end
      rescue StandardError => e
        puts "Error with #{str.text}: #{e.message}"
      end
    end
  end

  def get_all_the_urls_townhalls(url)
    page = Nokogiri::HTML(URI.open(url))
    page = page.css('a').select do |a|
      a['class'] == 'lientxt'
    end
    town_list = []
    page.first(5).each do |a|
      # page.sample(5).each do |a|
      # page.each do |a|
      email = get_the_email_of_a_townhal_from_its_webpage('http://annuaire-des-mairies.com' + '/' + a['href'][0..-1])
      town_list.push(name: a.text, email: email)
    rescue StandardError => e
      puts "Error with #{email}: #{e.message}"
    end
    town_list
  end
end
