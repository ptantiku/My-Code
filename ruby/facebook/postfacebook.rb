#!/usr/bin/env ruby
# encoding: utf-8

#using gem fb_graph
require 'fb_graph'

token = 'AAACEdEose0cBAMVPvHr9rghyyrvZBvpgwkfuZBcdfPMAFz9VXE6ZCXAajpfLtn0xAZC0IPUGZAloPZCUpZCliPHRBSTfWdQPcv9WDXN4Q0OEAZDZD'
#me = FbGraph::User.me(token)
#me = me.fetch  # data will not come, until fetch
#p me
#me.feed! message: "อ้าวทำไม OWASP มัน certificate ผิดล่ะเนี่ย" 


#ace = FbGraph::User.new('dickens.backhack1',access_token:token)
ace = FbGraph::User.fetch 'dickens.backhack1'
#ace = ace.fetch  # data will not come, until fetch
#p ace
puts ace.feed(access_token:token).first.to_json