#!/usr/bin/ruby

require 'benchmark'

def generate_first_k(a,b,c,r,k)
	set = []
	hash = Hash.new
	m = a
	#puts "\t0: m=#{m}"
	set << m
	hash[m]=1
	(k-1).times do |i|
		m = (b*m + c) % r
		#puts "\t#{i+1}: m=#{m}"
		set << m
		if hash.has_key?(m)
			hash[m]+=1 
		else
			hash[m]=1
		end
	end
	return set,hash
end

def find_next(first_k_set,first_k_hash,times)
	i=0
	new_val = nil
	remove_val = nil
	times.times do 
		if new_val.nil?
			i=0
		else
			if remove_val<new_val
				if first_k_hash.has_key?(remove_val)
					i=new_val
				else
					i=remove_val
				end
			else
				i=new_val
			end
		end
		#scan for value
		while(first_k_hash.has_key?(i)) do 
			i+=1
		end
		new_val=i

		#remove first data from set
		remove_val = first_k_set.shift
		if first_k_hash[remove_val]==1
			first_k_hash.delete(remove_val) 
		else
			first_k_hash[remove_val] -= 1
		end

		#adding new value
		first_k_set << new_val	
		if first_k_hash.has_key?(new_val)
			first_k_hash[new_val]+=1
		else
			first_k_hash[new_val]=1
		end
	end
	return new_val
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