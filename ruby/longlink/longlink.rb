#!/usr/bin/env ruby
# written by ptantiku

require 'open-uri'
require 'uri'
require 'net/http'

DEFAULT_SHORT_URL = 'http://preview.tinyurl.com/1c2'

if ARGV[0].nil? or ARGV[0]=='-h' or ARGV[0]=='--help'
    puts 'USAGE: ./longlink.rb [short URL]'
    exit 0
else
    shortURL = ARGV[0]
end

puts 'Input: '+shortURL

uri = URI(shortURL)

# usually 
#  - TinyURL uses "http://preview.tinyurl.com/#{shortURL}"
#  - Bit.Ly uses "http://api.bitly.com/v3/expand?login=#{login}&apiKey=#{apiKey}&shortUrl=#{shortURL}"

#but currently using generic case
puts 'Recursively redirection link'
count = 0
begin
	puts "Hop ##{count}: Link = " + shortURL
	uri = URI.parse(URI.encode(shortURL))
	response = Net::HTTP.get_response(uri)
	response_code = response.code.to_i
	if response_code.between?(300,399) #HTTP redirection code
	    shortURL = response['location']
	else
	    puts "Final Long Link = " + shortURL
	end
	count += 1
end while response_code.between?(300,399)
