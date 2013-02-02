#!/usr/bin/ruby

def parentheses_test(str)
	#test available characters [a-z:() ]
	if str =~ /[^a-z:() ]/
		return false
	end

	#count parenthesis
	counter=0
	c_emo_smile=str.scan(/:\)/).size
	c_emo_flown=str.scan(/:\(/).size

	str.split(//).each do |c|
		counter+=1 if c=='('
		counter-=1 if c==')'
		break if counter<0
	end

	return true if counter==0
	return true if counter<0 and counter+c_emo_smile>=0
	return true if counter>0 and counter-c_emo_flown<=0

	#else
	return false
end

out=open('out.txt','w')
open('sample.txt'){|f|
	lines = f.gets.chomp!
	case_no = 1;
	f.each_line{|line|
		line=line.chomp.downcase
		puts "# #{line}"
		output = parentheses_test(line)
		output = output ? "YES" : "NO"	
		puts "Case #{case_no}: #{output}"
		out.puts "Case #{case_no}: #{output}"
		case_no+=1
	}
}