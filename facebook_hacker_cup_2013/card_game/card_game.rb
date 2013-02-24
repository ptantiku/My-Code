def possibilities(k,n)
	k = [k,n-k].min
	p = q = 1
	(0...k).each{|i|
		p*=(n-i)
		q*=(1+i)
	}
	p/q
end

def max_k(a,k)
	t=Array.new(k,0)
	min = t[0]
	a.each{|i|
		if i > min
			changed = false
			(0...k-1).each{|j|
				if i<t[j+1]
					t[j] = i
					changed = true;
					break
				else
					t[j] = t[j+1]
				end
			}
			t[k-1]=i unless changed # for t = all 0
			min = t[0]
		end
	}
	return t
end

def card_game(a,k,n)
	# pre-calculate for the loops
	sub_poss_array = []
	n -= 1
	begin
		sub_poss = possibilities(k-1,n)
		sub_poss_array << sub_poss
		n -= 1
	end while sub_poss > 1

	# find maximum of "sub_poss_array.size" values
	t = max_k(a,sub_poss_array.size)
	
	# final calculate
	output = 0
	t_index = t.size-1
	sub_poss_array.each{|i|
		output += (t[t_index] % 1000000007) * (i % 1000000007) 
		t_index -= 1
	}

	return output % 1000000007
end

out=open('out.txt','w')
inputfile = ARGV.size==0 ? 'input.txt' : ARGV[0]
open(inputfile){|f|
	cases = f.gets.chomp!
	(1..cases.to_i).each{|case_no|
		# getting input from file
		line = f.gets	# line1
		n,k = line.split.map{|i| i.to_i}
		line = f.gets	# line2
		a = line.split.map{|i| i.to_i}
		#puts "input n=#{n} k=#{k}"
		#puts "a=#{a}"
		output = card_game(a,k,n)

		puts "Case #{case_no}: #{output}"
		out.puts "Case #{case_no}: #{output}"
	}
}