#!/usr/bin/env ruby
require 'parallel'
require 'ruby-progressbar'

progress = ProgressBar.create(:title => "The Progress", :total => 100)
Parallel.map(1..100, :finish => lambda { |item, i| progress.increment	}) { 
	# sleep 1 
	[*1..10000000].join(:+)
}

