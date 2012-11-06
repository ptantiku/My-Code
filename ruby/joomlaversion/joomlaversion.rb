#!/usr/bin/env ruby
# Author: Anidear
# Reference information from
# https://www.gavick.com/magazine/how-to-check-the-version-of-joomla.html

require 'net/http'
require 'uri'
require 'optparse'

# initialize global variables
$verbose = false;	
$all = false;

# parse input
OptionParser.new do |o|
	o.banner = 'Usage: joomlaversion.rb [options] url'
	o.on('-v', '--verbose', 'Run verbosely') { $verbose = true }
	o.on('-a', '--all', 'Run all tests') { $all = true }
	o.on('-h', '--help', 'Display help message') { puts o; exit }
	o.parse!
end

if ARGV.size<1
	puts 'No input URL'
	puts 'Try \'joomlaversion.rb -h\' for more options.'
	exit
end

# ----- Fetch & Match ------
class TestPattern
	attr_accessor :url, :pattern, :version
	
	def initialize args
		args.each do |k,v|
			instance_variable_set("@#{k}", v) unless v.nil?
		end
	end

	def test base_url
		url = base_url + @url
		url.gsub!(%r|([^:])//+|,'\1/')	#remove duplicated slash
		url = 'http://'+url unless url =~ %r|^http://| 
		result = fetch url
		if result.nil? 
			puts "[!] Cannot get response from #{url}" if $verbose
			return false;
		else
			puts "Test with '#{@pattern}'" if $verbose
			if result =~ Regexp.new(Regexp.escape(@pattern))
				puts "[+] Found! This is Joomla version #{@version}"
				return true
			else
				puts "[-] tested, but no result." if $verbose
				return false;
			end
		end
	end

	def fetch(url)
		max_redirect = 10
		begin
			puts "Loading #{url}" if $verbose
			uri = URI(url)
			response = Net::HTTP.get_response(uri)
			if response.is_a? Net::HTTPRedirection
				url = response['location']
				max_redirect -= 1
				puts "Redirection to #{url}" if $verbose
			else 
				unless response.is_a? Net::HTTPSuccess 
					puts "#{response.code} : \"#{response.msg}\"" if $verbose
					return nil
				end
			end
		end while response.is_a? Net::HTTPRedirection and max_redirect>0

		return response.body
	end
end

# -----PATTERNS------
pattern_set = [
	# Joomla 1.0.x
	TestPattern.new(
		url: '/templates/system/css/system.css',
		pattern: '<meta name="Generator" content="Joomla! - Copyright (C) 2005 - 2007 Open Source Matters." />',
		version: '1.0.x'),

	# Joomla 1.5
	TestPattern.new(
		url: '/templates/system/css/system.css',
		pattern: '/* OpenID icon style */',
		version: '1.5'),

	TestPattern.new(
		url: '/templates/system/css/template.css',
		pattern: '* @copyright Copyright (C) 2005 - 2010 Open Source Matters.',
		version: '1.5'),
	
	TestPattern.new(
		url: '/',
		pattern: '<meta name="generator" content="Joomla! 1.5 - Open Source Content Management" />',
		version: '1.5'),

	# Joomla 1.6
	TestPattern.new(
		url: '/templates/system/css/system.css',
		pattern: '* @version $Id: system.css 20196 2011-01-09 02:40:25Z ian $',
		version: '1.6'),
	
	# Joomla 1.7
	TestPattern.new(
		url: '/templates/system/css/system.css',
		pattern: '* @version $Id: system.css 21322 2011-05-11 01:10:29Z dextercowley $',
		version: '1.7'),

	# Joomla 1.8
	TestPattern.new(
		url: '/templates/system/css/system.css',
		pattern: '* @copyright    Copyright (C) 2005 - 2012 Open Source Matters',
		version: '1.8'),

	# Joomla 1.5 (via MooTools)
	TestPattern.new(
		url: '/media/system/js/mootools.js',
		pattern: 'MooTools={version:\'1.12\'}',
		version: '1.5'),

	# Joomla 1.6 (via MooTools)
	TestPattern.new(
		url: '/media/system/js/mootools-more.js',
		pattern: 'MooTools.More={version:"1.3.0.1"',
		version: '1.6'),

	# Joomla 1.7 (via MooTools)
	TestPattern.new(
		url: '/media/system/js/mootools-more.js',
		pattern: 'MooTools.More={version:"1.3.2.1"',
		version: '1.7'),

	# Joomla 2.5.6 (via MooTools)
	TestPattern.new(
		url: '/media/system/js/mootools-more.js',
		pattern: 'MooTools.More={version:"1.4.0.1"',
		version: '2.5.6'),

	# Joomla 3.0 alpha2 (via MooTools)
	TestPattern.new(
		url: '/media/system/js/mootools-more.js',
		pattern: 'MooTools.More={version:"1.4.0.1"',
		version: '3.0 alpha2'),

	# Joomla 1.5.26 (via Language)
	TestPattern.new(
		url: '/language/en-GB/en-GB.ini',
		pattern: '# $Id: en-GB.ini 11391 2009-01-04 13:35:50Z ian $',
		version: '1.5.26'),

	# Joomla 1.6.0 (via Language)
	TestPattern.new(
		url: '/language/en-GB/en-GB.ini',
		pattern: '; $Id: en-GB.ini 20196 2011-01-09 02:40:25Z ian $',
		version: '1.6.0'),

	# Joomla 1.6.5 (via Language)
	TestPattern.new(
		url: '/language/en-GB/en-GB.ini',
		pattern: '; $Id: en-GB.ini 20990 2011-03-18 16:42:30Z infograf768 $',
		version: '1.6.5'),

	# Joomla 1.7.1 (via Language)
	TestPattern.new(
		url: '/language/en-GB/en-GB.ini',
		pattern: '; $Id: en-GB.ini 20990 2011-03-18 16:42:30Z infograf768 $',
		version: '1.7.1'),

	# Joomla 1.7.3 (via Language)
	TestPattern.new(
		url: '/language/en-GB/en-GB.ini',
		pattern: '; $Id: en-GB.ini 22183 2011-09-30 09:04:32Z infograf768 $',
		version: '1.7.3'),

	# Joomla 1.7.5 (via Language)
	TestPattern.new(
		url: '/language/en-GB/en-GB.ini',
		pattern: '; $Id: en-GB.ini 22183 2011-09-30 09:04:32Z infograf768 $',
		version: '1.7.5'),

	# Joomla 2.5.0 - 2.5.4 (via Language)
	TestPattern.new(
		url: '/language/en-GB/en-GB.xml',
		pattern: '<version>2.5.0</version>',
		version: '2.5.0 - 2.5.4'),

	# Joomla 2.5.5 - 2.5.6 (via Language)
	TestPattern.new(
		url: '/language/en-GB/en-GB.xml',
		pattern: '<version>2.5.5</version>',
		version: '2.5.5 - 2.5.6')
]


# ----- Main -----
base_url = ARGV[0]

pattern_set.each do |pattern|
	result = pattern.test base_url
	break if result and not $all
end
