#!/usr/bin/env ruby
require 'thread'

def generate_dead_pixels(x, y, a, b, c, d, n, w, h)
	list = [{x:x,y:y}]
	prev = list[0]
	(1...n).each do |i|
		x = (prev[:x]*a+prev[:y]*b+1) % w
		y = (prev[:x]*c+prev[:y]*d+1) % h
		prev = {x:x, y:y}
		list << prev
	end
	list.sort!{|a,b| 
		if a[:x]!=b[:x]
			a[:x]<=>b[:x] 
		else
			a[:y]<=>b[:y] 
		end
	}
	return list
end

def find_next_x(prev_x,pixels)
	return nil if pixels.empty?
	pixels.each{|pixel|
		return pixel[:x] if pixel[:x]!=prev_x
	}
	return nil
end

def solve(w, h, p, q, n, x, y, a, b, c, d)
	dead_pixels_list = generate_dead_pixels(x, y, a, b, c, d, n, w, h)
	p dead_pixels_list

	count=0

	
	next_x = find_next_x(-1, dead_pixels_list)
	cur_x = 0
	puts "cur=#{cur_x} next=#{next_x} cur_count=#{count}"
	until next_x.nil? 
		if cur_x!=next_x
			count += (next_x-cur_x-p+1)*(h-q+1)
			puts "cur=#{cur_x} next=#{next_x} cur_count=#{count}"
		else
			(0..h-q).each do |j|
				found = false
				dead_pixels_list.each do |pixel|
					if (pixel[:x].between? cur_x,cur_x+p-1) and (pixel[:y].between? j,j+q-1)
						puts "scan found #{cur_x}:#{j}"
						found = true
						break
					end
				end
				count+=1 unless found
			end
			dead_pixels_list.delete_if{|pixel| pixel[:x] == cur_x}
		end
		cur_x = next_x
		next_x = find_next_x(cur_x,dead_pixels_list)
		puts "cur=#{cur_x} next=#{next_x} cur_count=#{count}"
	end

	if cur_x<w-p
		count += (w-p-(cur_x+1)+1)*(h-q+1)
	end

	return count
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