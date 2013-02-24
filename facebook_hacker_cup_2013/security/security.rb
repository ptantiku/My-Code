class String
	def count_question
		count=0
		self.each_char{|c| count+=1 if c=='?'}
		return count
	end
end
def try_find(k1,k2)
	out = []
	k1.each do |i|
		if i.include?('?')
			regex = Regexp.new(i.gsub('?','.?'))
			found_set = []
			k2.each do |j|
				if j =~ regex 
					found_set<<j
				end
			end
			
			if found_set.empty?
				# if not found, put it back
				out << i
			else
				# if found some, get the smallest
				found_set.sort!{|a,b| 
					c_a = a.count_question
					c_b = b.count_question
					o = 0
					if c_a!=0 && c_b!=0
						o = c_a <=> c_b
					elsif c_a!=0 || c_b!=0
						o = -1 if c_a==0
						o = +1 if c_b==0
					else
						o = a <=> b
					end
					o
				}
				#puts "found_set = #{found_set}"
				out << found_set[0]
			end
		else
			# solved word
			out << i
		end
	end
	out
end

def solve(k1,k2)
	puts "K1=#{k1}"
	puts "K2=#{k2}"

	20.times{
		k1 = try_find(k1,k2)
		#puts "k1new = #{k1_new}"
		k2 = try_find(k2,k1)
		#puts "k2new = #{k2_new}"
	}
	
	k1str = k1.sort.join
	k2str = k2.sort.join

	puts k1str
	puts k2str

	if k1str==k2str and k1str.count_question==0 and k2str.count_question==0
		return k1.join
	else
		return 'IMPOSSIBLE'
	end
end

out=open('out.txt','w')
inputfile = ARGV.size==0 ? 'input.txt' : ARGV[0]
open(inputfile){|f|
	cases = f.gets.chomp!
	(1..cases.to_i).each{|case_no|
		# getting input from file
		line = f.gets	# line1
		m = line.to_i
		line = f.gets	# line2
		k1 = line.chomp
		l = k1.size / m
		k1 = k1.scan(Regexp.new ".{#{l}}")
		line = f.gets	# line2
		k2 = line.chomp
		k2 = k2.scan(Regexp.new ".{#{l}}")
		
		output = solve(k1,k2)

		puts "Case #{case_no}: #{output}"
		out.puts "Case #{case_no}: #{output}"
	}
}