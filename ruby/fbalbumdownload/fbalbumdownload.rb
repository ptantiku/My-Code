#!/usr/bin/ruby

#####################################################################################
# This will download all pictures in an album (in original size) from Facebook.     #
# Restriction: availble for public albums only                                      #
#-----------------------------------------------------------------------------------#
# Auther: ptantiku                                                                  #
#-----------------------------------------------------------------------------------#
#####################################################################################

require 'net/http'
require 'net/https'

if ARGV.size < 3
    puts "This will download all pictures in an public album from Facebook."
    puts "USAGE: ./fbalbumdownload.rb [album id] [access token] [filter]"
    puts " album id:     first number group from the album's URL"
    puts "               for ex. http://www.facebook.com/media/set/?set=a.XXX.YYY.ZZZ"
    puts "               'XXX' is album ID"
    puts ""
    puts " access token: getting your own access token from " 
    puts "               https://developers.facebook.com/tools/explorer?method=GET"
    puts ""
    puts " filter:       specify whether to download: "
    puts "                  - \"original only\"(o)"
    puts "                  - \"original or normal size\"(on)"
    puts "                  - \"normalize only\"(n)"
    puts ""
    exit 0
end

REGEX_ORIGINAL_ONLY = /http[^"]+_o\.jpg/
REGEX_ORIGINAL_OR_NORMAL = /http[^"]+_[on]\.jpg/
REGEX_NORMAL_ONLY = /http[^"]+_n\.jpg/

albumID = ARGV[0]  #public
accessToken=ARGV[1]
case ARGV[2]
    when 'o':   filterType = REGEX_ORIGINAL_ONLY
    when 'on':  filterType = REGEX_ORIGINAL_OR_NORMAL
    when 'n':   filterType = REGEX_NORMAL_ONLY
    else filterType = REGEX_ORIGINAL_OR_NORMAL
end

# define download function to download a file
def download(url, filename)
    uri = URI.parse(url)
    f = open(filename,'wb')
    begin
        http = Net::HTTP.start(uri.host) {|http|
            http.request_get(uri.path) {|resp|
                resp.read_body {|segment|
                    f.write(segment)
                }
            }
        }
    ensure
        f.close()
    end
end

# start main #

http = Net::HTTP.new('graph.facebook.com',443)
http.use_ssl = true

### Get Photos ###
resp,data = http.get('/'+albumID+'/photos?access_token='+accessToken,nil)

#in case, cookie & header are needed
#cookie = resp.response['set-cookie']
#data = 'a=b&c=d&e=f'
#headers = {
#   'Cookie' => cookie,
#   'Referer' => 'http://www.example.com',
#   'Content-Type' => 'application/x-www-form-urlencoded'
#   'User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'
#}
#resp, data = http.post(path,data,headers)
#puts 'Code=' + resp.code
#puts 'Message=' + resp.message
#resp.each {|key, val| puts key + ' = ' + val}
#puts data

resultArray = data.scan(filterType)
downloadList = Hash.new
#find unique and higher resolution possible
resultArray.each{|url|
    url = url.gsub(/\\\//,'/').gsub(/^https/i,'http')
    photoID = /(\d+)_.\.jpg/i.match(url)[1]
    if downloadList[photoID].nil?
        downloadList[photoID] = url  #newly inserted
    elsif downloadList[photoID] =~ /_n\.jpg/i and url =~ /_o\.jpg/i 
        downloadList[photoID] = url  #override with higher resolution
    end
}

# start looping download
downloadList.each{|photoID,link|
    puts 'Downloading '+link+'...'
    filename = photoID+'.jpg'
    download(link, filename)
    puts 'Download Complete'
}


