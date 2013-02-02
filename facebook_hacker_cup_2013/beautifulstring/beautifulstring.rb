#!/usr/bin/ruby

def freq(str)
	h = {}
	str.downcase.split(//).each{|c|
		h.has_key?(c) ? h[c]+=1 : h[c]=1
	}
	h
end

out=open('out.txt','w')
open('beautiful_stringstxt.txt'){|f|
	lines = f.gets.chomp!
	case_no = 1;
	f.each_line{|line|
		line=line.chomp.downcase.gsub(/[^a-z]/,'')
		puts "# #{line}"
		h = freq(line)
		hv = h.values.sort
		i = 26-hv.size+1
		output=hv.inject(0){|sum,v| sum+=v*i; i+=1; sum}
		puts "Case #{case_no}: #{output}"
		out.puts "Case #{case_no}: #{output}"
		case_no+=1
	}
}