#!/usr/bin/env ruby
# code from https://gist.github.com/dustMason/5682810
require 'thread'

@threads = []
@num_of_threads = 8
@queue = Queue.new

# fill queue with items ...
10000000000.times{|i| 
	@queue << i
}
puts "done mocking data into queue"
  
@num_of_threads.times do
	@threads << Thread.new {
		sum=0
		loop do
			break if @queue.length == 0
			sum += @queue.deq
		end
	}
end
@threads.each { |thread| thread.join }
