#!/usr/bin/ruby

require 'benchmark'

def generate_first_k(a,b,c,r,k)
	set = []
	hash = Hash.new
	m = a
	#puts "\t0: m=#{m}"
	set << m
	hash[m]=:t
	(k-1).times do |i|
		m = (b*m + c) % r
		#puts "\t#{i+1}: m=#{m}"
		set << m
		hash[m]=:t
	end
	return set,hash
end

def find_next(first_k_set,first_k_hash,times)
	i=0
	times.times do 
		i=0
		while(first_k_hash.has_key?(i)) do 
			i+=1
		end
		del = first_k_set.shift
		first_k_set << i
		
		first_k_hash.delete(del) if !first_k_set.include?(del)
		first_k_hash[i]=:t
	end
	return i
end

Benchmark.bm(1) do |report|
	out=open('out.txt','w')
	open('sample2.txt'){|f|
		lines = f.gets.chomp!
		case_no = 1;
		lines.to_i.times{|case_no|
			case_no+=1
			# getting input from file
			line = f.gets.chomp!	# line1
			n,k = line.split.map{|i| i.to_i}
			line = f.gets.chomp!	# line2
			a,b,c,r = line.split.map{|i| i.to_i}
		
			report.report("Case #{case_no}") do 
				puts "\n#{case_no}: #{k}/#{n}: a=#{a} b=#{b} c=#{c} r=#{r}"

				#generate first k set
				first_k_set, first_k_hash = generate_first_k(a,b,c,r,k)
				output = find_next(first_k_set,first_k_hash,n-k)
				puts "Case #{case_no}: #{output}"
				out.puts "Case #{case_no}: #{output}"
			end
		}
	}
end