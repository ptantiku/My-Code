#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'net/http'
require 'uri'

# install net-http-persistent 
#	sudo gem install net-http-persistent)

proxy = URI('proxy://111.1.33.138:80')
puts "HOST: #{proxy.host}"
puts "PORT: #{proxy.port}"

Net::HTTP::Proxy(proxy.host, proxy.port).start('ifconfig.me') do |http|
	resp = http.get('/json')
	puts "RESPONSE: #{resp.code} (#{resp.message})"
	puts resp.body
end

#puts resp.code
#puts resp.message
#puts resp.body