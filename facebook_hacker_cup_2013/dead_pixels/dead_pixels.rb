#!/usr/bin/env ruby
require 'thread'

def generate_dead_pixels(x, y, a, b, c, d, n, w, h)
	l = [{:x => x,:y => y}]
	prev = l[0]
	(1...n).each do |i|
		x = (prev[:x]*a+prev[:y]*b+1) % w
		y = (prev[:x]*c+prev[:y]*d+1) % h
		prev = {:x => x,:y => y}
		l << prev
	end
	l.sort!{|a,b| 
		if a[:x]!=b[:x]
			a[:x]<=>b[:x] 
		else
			a[:y]<=>b[:y] 
		end
	}
	return l
end

def solve(w, h, p, q, n, x, y, a, b, c, d)
	dead_pixels_list = generate_dead_pixels(x, y, a, b, c, d, n, w, h)
	#p dead_pixels_list

	max_threads = 4
	threads = []
	
	x_split = (w-p+1).to_f/max_threads
	max_threads.times do |t|
		x_start = (x_split*t).to_i
		x_end = (x_split*(t+1)).to_i
		threads[t] = Thread.new do 
			Thread.current['x_start'] = x_start
			Thread.current['x_end'] = x_end
			puts "Thread #{t}: (#{x_start}...#{x_end})"
			count=0
			(x_start...x_end).each do |i|
				#dead_pixels_list.delete_if{|pixel| pixel[:x] < i}
				(0..h-q).each do |j|
					found = false
					dead_pixels_list.each do |pixel|
						if (pixel[:x].between? i,i+p-1) and (pixel[:y].between? j,j+q-1)
							found = true
							break
						end
					end
					count+=1 unless found
				end
			end
			Thread.current['count'] = count
		end
	end

	total_count=0
	threads.each{|t|
		t.join
		total_count+=t['count']
	}

	return total_count
end

out=open('out.txt','w')
inputfile = ARGV.size==0 ? 'input.txt' : ARGV[0]
open(inputfile){|f|
	cases = f.gets.chomp!
	(1..cases.to_i).each{|case_no|
		# getting input from file
		line = f.gets	# line1
		w, h, p, q, n, x, y, a, b, c, d = line.split.map{|i| i.to_i}
		#puts [w, h, p, q, n, x, y, a, b, c, d].inspect
		output = solve(w, h, p, q, n, x, y, a, b, c, d)

		puts "Case #{case_no}: #{output}"
		out.puts "Case #{case_no}: #{output}"
	}
}