# mass_emails

This projects aims to inform every townhall that THP exists.
Our team : Ani, Badr, Fadia, Kamus, Tibo

We chose to focus on these 3 french departements:
- Ain
- Loire
- Aisne

The script works in 3 steps:
1. collects the emails of each townhall by scrapping their websites, and saving them in a JSON file
2. send an email to each of them, with a message presenting the formation
3. send a tweet at each townhall to make sure they heard us

### How to use

Install all the gems
```sh
bundle install
```
Run the script
```sh
ruby app.rb
```

## About the project
```sh
.mass_emails
├── Gemfile
├── README.md
├── app.rb
├── db
│   ├── ain_emails.JSON
│   ├── aisne_emails.JSON
│   └── loire_emails.JSON
└── lib
    ├── townhall_mailer.rb
    ├── townhall_scrapper.rb
    └── twitter_follow.rb
```
`app.rb` starts the app, and pieces the different parts together
`db/` contains the JSON files, they will not be pushed on the github, the user will have to generate them
`lib/` contains the classes used to scrapp, tweet and send emails, they are describe bellow

## Description of the classes used

### TownhallScrapper: handles the scrapping of the townhalls emails
```ruby
TownhallScrapper.new(url)
```
Initialize a scrapping object for `url`
```ruby
TownhallScrapper.list_from_url
```
Scrapps the url and generates an array of hashes `{name: "city_name", email: "city_email"}`
```ruby
TownhallScrapper.write_json_list(filename)
```
Creates `filename` and stores the previous hash in JSON format
```ruby
TownhallScrapper.read_json_from_db(filename)
```
Reads `filename`, a JSON file and returns an array of hashes `{name: "city_name", email: "city_email"}`

### TwitterFollow: follows every cityhall on Twitter
```ruby
TwitterFollow.new(file.JSON)
```
Initialize the object with the JSON file and create a hash from it
```ruby
TwitterFollow.follow
```
Finds the Twitter accounts of each city and follows them. Updates the JSON file with the Twitter handles
```ruby
TwitterFollow.update_json
```
Updates the JSON to `{name: "city_name", email: "city_email", handle: "@handle"}`

### TownhallsMailer: sends a mail to every cityhall to tell them about the formation
```ruby
TownhallMailer.new(json_file)
```
Initialize an object with a hash `{name: "city_name", email: "city_email"}` from the json file
```ruby
TownhallMailer.send_email
```
Send an email to every address in the hash


## Gem used

- `nokogiri` scrapper gem
- `pry` testing gem
- `rubocop` synthax check
- `twitter` twitter API access
- `gmail` gmail API access
- `dotenv` secure login

## Impact
At full power, we can contact about 1500 townhalls, and we followed twitter handles from our twitter account fadia76111880
