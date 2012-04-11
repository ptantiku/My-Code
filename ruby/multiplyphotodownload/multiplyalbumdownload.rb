#!/usr/bin/env ruby

#####################################################################################
# This will download all pictures in your multiply.                                 #
# Pre-requisite: gem install json                                                   #
# USAGE:                                                                            #
#  ./multiplyphotodownload.rb [username] [password] [developer_api_key] [directory] [albumid] #
#     username: your username or value xxxxx in  http://xxxxx.multiply.com/...      #
#     password: your password.                                                      #
#     developer_api_key: getting your own API key from                              #
#                             http://multiply.com/apis/developer-key                #
#     director(optional): directory to save photos to (default=current directory)   #
#     albumid(optional): album id (default='all')                                   #
#-----------------------------------------------------------------------------------#
# Auther: ptantiku                                                                  #
#-----------------------------------------------------------------------------------#
#####################################################################################

require 'net/http'
require 'json'

if ARGV.size < 3
    puts "This will download all pictures in your multiply."
    puts "USAGE: ./multiplyphotodownload.rb [username] [password] [developer_api_key] [directory] [albumid]"
    puts "\tusername: your username or value xxxxx in  http://xxxxx.multiply.com/..."
    puts "\tpassword: your password."
    puts "\tdeveloper_api_key: getting your own API key from http://multiply.com/apis/developer-key"
    puts "\tdirector(optional): directory to save photos to (default=current directory)"
    puts "\talbumid(optional): album id (default=all albums)"
    puts ""
    exit 0
end

uname = ARGV[0].nil? ? 'AAAAA' : ARGV[0]
password = ARGV[1].nil? ? 'BBBBB' : ARGV[1]
api_key = ARGV[2].nil? ? 'CCCCC' : ARGV[2]
directory = ARGV[3].nil? ? '.' : ARGV[3]
albumid = ARGV[4].nil? ? 'all' : ARGV[4]

### define download function to download a file ###
def download(url, filename)
    uri = URI.parse(url)
    f = open(filename,'wb')
    begin
        http = Net::HTTP.start(uri.host) {|http|
            http.request_get(uri.request_uri) {|resp|
                resp.read_body {|segment|
                    f.write(segment)
                }
            }
        }
    ensure
        f.close()
    end
end

### Initialize HTTP Connection ###
http = Net::HTTP.new("#{uname}.multiply.com",80)

### Get Profile ###
resp = http.get("/api/profile.json?api_key=#{api_key}&password=#{password}")
if resp.code != '200'
	error_msg = $1
	puts "ERROR! #{error_msg}"
	exit(0)
end
data = resp.body
profile = JSON.parse data
puts "[+] Name: " + profile['name'] #name = /"name":"([^"]*)"/.match(data)[1]
puts "[+] Email: " + profile['email'] #email = /"email":"([^"]*)"/.match(data)[1]
puts "[+] Albums: " + profile['num_photos'] #albums = /"num_photos":"([^"]*)"/.match(data)[1]
puts "[+] Videos: " + profile['num_video'] #videos = /"num_video":"([^"]*)"/.match(data)[1]
puts "[+] Musics: " + profile['num_music'] #musics = /"num_music":"([^"]*)"/.match(data)[1]
puts '--------------------------------------------'

total_albums = profile['num_photos'].to_i

### Get Album List ###
### Comment retrieve by album, since each album can access directly with an id, and it is consecutive ###
=begin
albums = []
count = 0
while count < total_albums   #paging
	resp = http.get("/api/read.json?api_key=#{api_key}&password=#{password}&type=photos&start=#{count}")
	data = resp.body
	dataObj = JSON.parse data
	dataObj['items'].each{|item|
		desc = item['value']
		puts "Album ##{count}"
		puts "\t[+] Subject: " + desc['subject'] unless desc['subject'].nil?
		puts "\t[+] Summary: " + desc['summary'] unless desc['summary'].nil?
		puts "\t[+] Photos: "  + desc['num_photos'].to_s unless desc['num_photos'].nil?
		puts "\t[+] Item_Key: "+ desc['item_key'] unless desc['item_key'].nil?
		puts "\t--------------------------------------------"
		count+=1
	}
	albums += dataObj['items']
end
=end


#change to saving directory
oldpath = Dir.pwd
Dir.chdir directory

# define which album to download
if albumid=='all'
	albumlist = (1..total_albums)	# all albums
else
	albumlist = (albumid..albumid)	# single album
end

### For Each Album ###
albumlist.each{|albumid|
	puts "Album ##{albumid}"
	resp = http.get("/api/read.json?api_key=#{api_key}&password=#{password}&type=photos&item_key=#{uname}:photos:#{albumid}")
	data = resp.body
	album = JSON.parse data
	### Retrieve Album's Description ###
	puts "[+] Subject: " + album['subject'] unless album['subject'].nil?
	puts "[+] Summary: " + album['body'] unless album['body'].nil?
	puts "[+] Created Date: " + album['created_date'] unless album['created_date'].nil?
	puts "[+] Photos: "  + album['num_photos'].to_s unless album['num_photos'].nil?
	puts "[+] Item_Key: "+ album['item_key'] unless album['item_key'].nil?
	puts "--------------------------------------------"
	albumname = "album%04d-%s" % [albumid,album['subject']]
	albumname.gsub!(/[\/+]/,'-')	#replace any '/' or '+' character
	
	# skip if blank album
	next if album['num_photos'].nil? or album['num_photos']==0

	### Retrieve Each Photo ###
	filelist = []
	album['photos'].each{|photo|
		photo_desc = photo['value']
		puts "  [+] Caption: " + photo_desc['caption'] unless photo_desc['caption'].nil?
		puts "  [+] Description: "+ photo_desc['description'] unless photo_desc['description'].nil?
		puts "  [+] Item_Key: "+ photo_desc['item_key'] unless photo_desc['item_key'].nil?
		puts "  [+] Src: "+ photo_desc['src'] unless photo_desc['src'].nil?
		filelist << {'name'=>photo_desc['caption'], 'url'=>photo_desc['src']}
	}

	### creating new directory for this album ###
	puts "[+] Creating Directory #{albumname}"
	Dir.mkdir albumname unless Dir.exist?(albumname)
	Dir.chdir albumname
	### download each file ###
	filelist.each{|file|		
		puts "Downloading #{file['name']}"
		file['name'].gsub!(/[\/+]/,'-')	#replace any '/' character
		file['name']+='.jpg' unless file['name'] =~ /\.(jpg|gif)$/i  #if no extension, append with .jpg
		begin
			download(file['url'],file['name'])
		rescue Exception => e
			puts "ERROR: Cannot Download #{file['name']} from #{file['url']}"
			STDERR.puts "ERROR: Cannot Download #{file['name']} from #{file['url']}"
			puts e.message
			puts e.backtrace.inspect
		end 
	}
	Dir.chdir ".."	#back one directory
	puts "*********************************************************************************"
}

Dir.chdir oldpath


