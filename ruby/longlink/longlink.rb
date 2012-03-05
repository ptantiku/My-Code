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
case uri.host 
when /^.*tinyurl.com$/i 
	puts 'Detected short-URL type: TinyURL'
    open('http://preview.tinyurl.com'+uri.path){ |f|
    	data = f.read
    	longURL = /<blockquote><b>(http:[^<]*)<br/i.match(data)[1]
    	unless longURL.nil?
    		puts 'Long Link = ' + longURL
    	else
    		puts 'Long Link = Not Found.'
    	end
    }
when /^.*(bit\.ly|j\.mp)$/i 
	puts 'Detected short-URL type: BitLy'
	#old method
    #open('http://'+ uri.host + uri.path + '+'){ |f|
    #	data = f.read
    #	longURL = /Long Link:<\/span>[^<]*<a href=["'](http[^"']+)["']/i.match(data)[1]
    #	puts 'BitLy\'s Long Link = ' + longURL
    #	}

	# new method using API 
	# API doc @ https://code.google.com/p/bitly-api/wiki/ApiDocumentation

    login = 'ptantiku'
    apiKey = 'R_1cbc330ba8fb85e9277464d73eb435e7'
    open("http://api.bitly.com/v3/expand?login=#{login}&apiKey=#{apiKey}&shortUrl=#{shortURL}"){|f|
        data = f.read
        unless data =~ /"error"/
	        longURL = /"long_url": "([^"]+)"/.match(data)[1]
	        longURL = longURL.gsub(/\\\//,'/')

	        puts 'Long Link = ' + longURL
        else
	        puts 'Long Link = Not Found.'
        end
    }
else
    #other link-shortening services else
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
end

