#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'socket'
require 'open-uri'
require 'hpricot'

# Parsing Input
options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: youtube_playlist_dl.rb [options] playlist_url"

	opts.on("-v", "--verbose", "Run verbosely") do |v|
		options[:verbose] = v
	end

	opts.on("-n", "--name", "Show name of the videos") do |n|
		options[:show_name] = n
	end

	opts.on("-d", "--download", "Download the videos") do |d|
		options[:download] = d
	end

	opts.on("-h", "--help", "Display help message") do 
		puts opts
		exit
	end	
end.parse!

if ARGV.size >= 1
	playlist_url = ARGV[0]
else
	# default
	playlist_url = 'http://www.youtube.com/playlist?list=PLZaG0MNecryMecGObCWwf2pNkiYEaZEDO'
end

doc = open(playlist_url){|f| Hpricot(f)}
links = doc.search('//*[@id="playlist-pane-container"]/div[1]/div/ol/li/div/div[2]/div/h3/a')
puts "Playlist Size = #{links.size}"	if options[:verbose]
links.each do |link|
	title = link.search('//span').inner_text
	
	# filter only for parameter v
	params = link.get_attribute('href')
	v_param = params.match(/(v=[^&]+)/)[1]
	link_url = 'http://www.youtube.com/watch?'+v_param	# filter only for parameter v
	
	# display result
	if options[:show_name]
		puts title+"\t"+link_url
	else
		puts link_url
	end

	# download
	if options[:download]
		system "youtube-dl -t #{link_url}"
	end
end
