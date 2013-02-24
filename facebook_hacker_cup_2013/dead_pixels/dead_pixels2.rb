#!/usr/bin/env ruby
require 'thread'

def print_screen(screen)
	size_x = screen.size
	size_y = screen[0].size
	size_y.times{|row|
		size_x.times{|col|
			print screen[col][row]
		}
		puts
	}
end

def paint(screen,x,y,p,q)
	size_x = screen.size
	size_y = screen[0].size
	puts "Paint at #{x},#{y}"
	([x-p+1,0].max .. [x,size_x-1].min).each do |i|
		([y-q+1,0].max .. [y,size_y-1].min).each do |j|
			#puts "Test at #{i}:#{j} ==> #{i**2+j**2 < sqr_radius}"
			puts "\tput #{i}:#{j}"
			screen[i][j]=0 
		end
	end
end

def generate_dead_pixels(x, y, a, b, c, d, n, w, h, p, q)
	size_x = w-p+1
	size_y = h-q+1
	screen = Array.new(size_x){Array.new(size_y,1)}
	list = []
	prev = {x:x,y:y}
	list << prev
	paint(screen,x,y,p,q)
	(1...n).each do |i|
		x = (prev[:x]*a+prev[:y]*b+1) % w
		y = (prev[:x]*c+prev[:y]*d+1) % h
		prev = {x:x, y:y}
		list << prev
		if(x<size_x and y<size_y)
			paint(screen,x,y,p,q)
		end
	end
	p list
	return screen
end

def solve(w, h, p, q, n, x, y, a, b, c, d)
	screen = generate_dead_pixels(x, y, a, b, c, d, n, w, h, p, q)
	print_screen(screen)
	#p dead_pixels_list

	total_count=0
	screen.each do |row|
		total_count += row.inject(&:+)
	end


	return total_count
end

#out=open('out.txt','w')
inputfile = ARGV.size==0 ? 'input.txt' : ARGV[0]
open(inputfile){|f|
	cases = f.gets.chomp!
	(1..cases.to_i).each{|case_no|
		# getting input from file
		line = f.gets	# line1
		w, h, p, q, n, x, y, a, b, c, d = line.split.map{|i| i.to_i}
		#puts "input n=#{n} k=#{k}"
		#puts "a=#{a}"
		puts [w, h, p, q, n, x, y, a, b, c, d].inspect
		output = solve(w, h, p, q, n, x, y, a, b, c, d)

		puts "Case #{case_no}: #{output}"
		#out.puts "Case #{case_no}: #{output}"
	}
}