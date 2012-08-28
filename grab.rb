require 'open-uri'
require 'json'

if ARGV.size != 2
  puts "usage: ruby grab.rb api_key user"
  exit 0
end

API_KEY = ARGV.shift
user = ARGV.shift

puts "fetching #{user} with api key #{API_KEY}"

def get(user, page = 1)
  url = "http://ws.audioscrobbler.com/2.0/?format=json&method=user.getrecenttracks&limit=200"
  url += "&user=#{user}"
  url += "&api_key=#{API_KEY}"
  url += "&page=#{page.to_s}"
  json_object = JSON.parse(open(url).read)
end

f = File.open('data.json', 'w')
f.write '['

index = 1
total_page = 1

while index <= total_page
  puts "grabbing #{index}..."

  json_object = get(user, index)

  tracks = json_object['recenttracks']['track']
  total_page = json_object['recenttracks']['@attr']['totalPages'].to_i
  tracks.each do |t|
    f.write t
    f.write ", \n"
  end
  index += 1
  sleep 1
end

f.write ']'
