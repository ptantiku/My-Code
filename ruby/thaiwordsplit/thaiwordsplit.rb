#!/usr/bin/env ruby
# encoding: utf-8
require 'libthai4r'

input_file_path = 'output.txt'
output_file_path = 'outwords.txt'

count = 0
table = Hash.new

#open input file
File.open(input_file_path,'r') do |file|
	file.each_line do |line|
		split1 = LibThai4R::brk_line(line.encode('CP874', :undef => :replace,:replace => ''))
		split2 = split1.encode('UTF-8','CP874')
		splitArr = split2.split('|')
		splitArr.each do |word|
			if table.has_key? word
				table[word] = table[word]+1
			else
				table[word] = 1
			end
		end
		count+=1
		puts "Line ##{count}..." if count % 20 == 0
	end
	file.close
end

#set output file
outfile = File.open(output_file_path,'w+')
table.sort_by{|k,v| v}.reverse.each do |pair|
	outfile.puts "#{pair[0]}\t:\t#{pair[1]}"
end
outfile.close