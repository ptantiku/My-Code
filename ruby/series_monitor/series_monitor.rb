#!/usr/bin/env ruby

=begin
Series Monitor: monitoring series or manga specified in config.yml file
Author: ptantiku
Required Packages: 
	- 'libnotify' (use 'gem install libnotify' to install)
	- 'libnotify-bin','libnotify-dev' (use 'sudo apt-get install libnotify-bin libnotify-dev -y' to install)
=end

require 'open-uri'
require 'yaml'
require 'rubygems'
require 'libnotify'
require './fetchsite.rb'

# global DEBUG
$debug = false

# load config
config = YAML.load_file('config.yml')
puts config.inspect

# for each site, load data
config['sites'].each do |site|
	puts '*' * 50	# start site
	puts "Name = #{site['name']}"
	puts "Keywords = #{site['keywords']}"
	puts '-' * 50

	# load plugin
	fetch_class_file = "fetch_#{site['name'].downcase.split.join('_')}";
	fetch_class_name = fetch_class_file.split(/_/).map(&:capitalize).join
	require "./plugins/#{fetch_class_file}.rb"
	fetch_class = Kernel.const_get(fetch_class_name)

	# fetch page and filter by keywords for results
	results = fetch_class.new.fetch(site['keywords'])
	if results.empty?
		puts "[-] nothing matched."
	else
		results.each do |result|
			puts "[+] #{result[:title]}"
			puts ">>> #{result[:link]}"
			puts ''
			Libnotify.show(
				:summary => result[:title], 
				:body => "Click on <a href=\"#{result[:link].gsub('&','%38')}\">LINK</a> to see/download.",
				:timeout => config['config']['timeout'], 
				:urgency => :low)
		end
	end

	puts '*' * 50	# end site
end
