# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'json'
require 'gmail'
require_relative 'townhall_scrapper'
require 'dotenv/load'

class TownhallMailer
  def initialize(mailing_list = '', departement = '')
    @mailing_list = if mailing_list == ''
                      "db/ain_emails.JSON"
                    else
                      mailing_list
                    end
    @name_and_mail = TownhallScrapper.new(mailing_list, departement)
  end

  def g_email
    read_file = @name_and_mail.read_json_from_db(@mailing_list)
    emails = []

    read_file.each do |city|
      emails << city["email"]
    end
    emails
  end

  def g_name
    read_file = @name_and_mail.read_json_from_db(@mailing_list)
    names = []
    read_file.each do |city|
      names << city["name"]
    end
    names
  end

  def send_email
    n_commune = g_name
    mail = g_email
    Gmail.connect(ENV['USERNAME'], ENV['PASSWORD']) do |gmail|
      mail.each_with_index do |email, i|
        gmail.deliver do
          to email
          subject "Presentation du Projet THP!"
          html_part do
            content_type 'text/html; charset=UTF-8'
            body "<p>Bonjour,</p> <p>Je m'appelle Ninad, je suis élève à The Hacking Project, une formation au code gratuite, sans locaux, sans sélection, sans restriction géographique.
            La pédagogie de ntore école est celle du peer-learning, où nous travaillons par petits groupes sur des projets concrets qui font apprendre le code.
            Le projet du jour est d'envoyer (avec du codage) des emails aux mairies pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation pour tous.</p>
            <p>Déjà 500 personnes sont passées par The Hacking Project. Est-ce que la mairie de #{n_commune[i]} veut changer le monde avec nous ?<p>
            </br>Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80</p>"
          end
        end
        gmail.logout
      end
    end
  end
end
