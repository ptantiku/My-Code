#!/usr/bin/env ruby
#############################################################################################
# Ruby version of AutoPost -- continuously POST HTTP packet to a web server                 #
# : original by MaYaSeVeN (https://github.com/MaYaSeVeN/Auto_POST/blob/master/auto_post.py) #
# ------------------------------------------------------------------------------------------#
# Author: ptantiku                                                                          #
#############################################################################################
require 'uri'
require 'net/http'

def random_string
    size = [*4..12].choice
    charsets = [*'a'..'z'] + [*'0'..'9']
    return (1..size).to_a.collect{ charsets.choice}.join
end

if ARGV.include?('-h') or ARGV.length < 2 
    puts "./autopost [URL] [fields [field]...]"
    exit
end

url = URI.parse(ARGV[0])
fields = ARGV[1..ARGV.length]

sleepTime = 1.0;
count = 1;
http = Net::HTTP.new(url.host,80)
while( true ) do 
    
	data = fields.collect{ |field|
	    if field =~ /email/i
	        email = 
        "#{field}=" + random_string() + ['@hotmail.com','@gmail.com','@facebook.com','@windowslive.com'].choice
        else
	        "#{field}=#{random_string()}"
	    end
    }.join('&')
    
	headers = {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'User-Agent' => 'Mozilla/5.0'
    }
	resp = http.post(url.path,data,headers)
	#puts resp.body   #not showing data
	
	sleep(sleepTime)
	puts "#{data} #{count}"
	count = count + 1
end
