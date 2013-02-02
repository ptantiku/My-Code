#!/usr/bin/ruby

#constants
INITIAL_PERMUTATION = [	58,50,42,34,26,18,10,2,
						60,52,44,36,28,20,12,4,
						62,54,46,38,30,22,14,6,
						64,56,48,40,32,24,16,8,
						57,49,41,33,25,17,9,1,
						59,51,43,35,27,19,11,3,
						61,53,45,37,29,21,13,5,
						63,55,47,39,31,23,15,7	]

PC1 = [	57,49,41,33,25,17,9,
		1,58,50,42,34,26,18,
		10,2,59,51,43,35,27,
		19,11,3,60,52,44,36,
		63,55,47,39,31,23,15,
		7,62,54,46,38,30,22,
		14,6,61,53,45,37,29,
		21,13,5,28,20,12,4]

KEY_ROTATE_PER_ROUND = [1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1]

PC2 = [	14,17,11,24,1,5,
		3,28,15,6,21,10,
		23,19,12,4,26,8,
		16,7,27,20,13,2,
		41,52,31,37,47,55,
		30,40,51,45,33,48,
		44,49,39,56,34,53,
		46,42,50,36,29,32]

EXPANSION_PERMUTATION = [	32,1,2,3,4,5,
							4,5,6,7,8,9,
							8,9,10,11,12,13,
							12,13,14,15,16,17,
							16,17,18,19,20,21,
							20,21,22,23,24,25,
							24,25,26,27,28,29,
							28,29,30,31,32,1]

S1 = [	14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7,
		0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8,
		4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0,
		15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13]
S2 = [	15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10,
		3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5,
		0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15,
		13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9]
S3 = [	10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8,
		13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1,
		13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7,
		1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12]
S4 = [	7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15,
		13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9,
		10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4,
		3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14]
S5 = [	2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9,
		14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6,
		4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14,
		11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3]
S6 = [	12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11,
		10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8,
		9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6,
		4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13]
S7 = [	4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1,
		13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6,
		1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2,
		6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12]
S8 = [	13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7,
		1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2,
		7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8,
		2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11]

S = [S1,S2,S3,S4,S5,S6,S7,S8]

P = [	16,7,20,21,
		29,12,28,17,
		1,15,23,26,
		5,18,31,10,
		2,8,24,14,
		32,27,3,9,
		19,13,30,6,
		22,11,4,25]

INVERT_INITIAL_PERMUTATION = [	40,8,48,16,56,24,64,32,
								39,7,47,15,55,23,63,31,
								38,6,46,14,54,22,62,30,
								37,5,45,13,53,21,61,29,
								36,4,44,12,52,20,60,28,
								35,3,43,11,51,19,59,27,
								34,2,42,10,50,18,58,26,
								33,1,41,9,49,17,57,25]

def sbox(val,index)
	s = S[index]
	row = (val[0]+val[5]).to_i(2)
	col = (val[1..4]).to_i(2)
	"%04b" % s[row*16 + col]
end

def display(bin_string,format,split=8,delimiter='')
	words = bin_string.scan(Regexp.new(".{#{split}}"))
	words.map! do |word|
		word.to_i(2)
	end

	case format 
		when :bin 
			puts words.map{|w| '%08b' % w}.join(delimiter)
		when :hex
			puts words.map{|w| '%02x' % w}.join(delimiter)
		when :char
			puts words.map{|w| '%c' % w}.join(delimiter)
	end
end

####### MAIN ########
require 'optparse'
options = {
	:verbose => false,
	:plaintext => nil, #"abcdefghijklmnopqrstuvwxyz",
	:key => "itisakey",
	:format => :hex
}

opts = OptionParser.new
opts.banner = "Usage: des_encrypt.rb [options] DES_cipher"
opts.separator ""
opts.separator "Options: "

opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
	options[:verbose] = v
end
opts.on('-k KEY', '--key KEY', String, 'Key for encryption') do |k|
	options[:key] = k
end
opts.on("-p PLAINTEXT", "--plaintext PLAINTEXT", String, 'Plaintext before encryption') do |p|
	options[:plaintext] = p
end
opts.on("-i", "--iteration", String, 'Display output of each iteration') do |i|
	options[:iteration] = i
end
opts.on('-f FORMAT','--format FORMAT', [:bin,:hex,:char], 'Display output in different format [bin,hex,char]') do |f|
	options[:format] = f
end
opts.on('-b', '--binary', 'Display output in binary format') do 
	options[:format] = :bin
end
opts.on('-h', '--hex', 'Display output in hexadecimal format') do 
	options[:format] = :hex
end
opts.on('-c', '--char', 'Display output in character(ASCII) format') do 
	options[:format] = :char
end
opts.on('-d DELIMITER', '--delimiter DELIMITER', String, 'Display delimiter between bytes') do |d|
	options[:delimiter] = d
end
opts.parse!

if ARGV.empty?
	puts opts
	exit
end

options[:plaintext] = ARGV[0]
final_output = ""

#convert input to blocks
input_binary = options[:plaintext].unpack('B*')[0]
input_binary_block = input_binary.scan(/[01]{1,64}/)

input_binary_block.each do |input_block|

	#padding block, if block_size < 64bit
	input_block = (input_block + "0"*64)[0...64]
	puts "Input bits: #{input_block.scan(/.{8}/).join(' ')}" if options[:verbose]

	#initial permutation
	input_after_initial_permutation = INITIAL_PERMUTATION.map{|i| input_block[i-1]}.join

	#split input to left, right
	input_left, input_right = input_after_initial_permutation[0...32], input_after_initial_permutation[32...64]

	#key generation
	key_binary = options[:key].unpack('B64')[0]
	print "Key bits: " if options[:verbose]
	display(key_binary,options[:format],8,options[:delimiter]) if options[:verbose]

	#First permutation (PC1) 56bit
	key_after_pc1 = PC1.map{|i| key_binary[i-1]}.join
	puts "KPC1:  #{key_after_pc1.scan(/.{7}/).join(' ')}" if options[:verbose]
	key_left, key_right = key_after_pc1[0...28], key_after_pc1[28...56]
	puts "CD[0]:  #{(key_left+key_right).scan(/.{7}/).join(' ')}" if options[:verbose]

	# 16 ITERATIONS OF
	16.times do |round|
		puts "Round #{round+1}" if options[:verbose]

		#rotate key(26bit each)
		key_left = key_left.scan(/./).rotate(KEY_ROTATE_PER_ROUND[round]).join
		key_right = key_right.scan(/./).rotate(KEY_ROTATE_PER_ROUND[round]).join
		#puts "CD[#{round+1}]:  #{(key_left+key_right).scan(/.{7}/).join(' ')}"

		#Second permutation (PC2) 56bit-->48bit
		key_before_pc2 = key_left + key_right
		key_after_pc2 = PC2.map{|i| key_before_pc2[i-1]}.join
		#puts "KS[#{round+1}]:  #{key_after_pc2.scan(/.{6}/).join(' ')}"
		
		#Expansion Permutation(32bits --> 48bits)
		input_right_after_expansion = EXPANSION_PERMUTATION.map{|i| input_right[i-1]}.join
		puts "E   :  #{input_right_after_expansion.scan(/.{6}/).join(' ')}" if options[:verbose]
		puts "KS  :  #{key_after_pc2.scan(/.{6}/).join(' ')}" if options[:verbose]

		#XOR key with the right input(after expansion)
		input_right_after_xor = ""
		48.times do |i|
			input_right_after_xor += (input_right_after_expansion[i].to_i(2) ^ key_after_pc2[i].to_i(2)).to_s(2)
		end
		puts "E xor KS:  #{input_right_after_xor.scan(/.{6}/).join(' ')}" if options[:verbose]

		#S-Box(48bit --> 32bit)
		input_right_before_sbox = input_right_after_xor.scan(/.{6}/)
		input_right_before_sbox.each_with_index do |val,index|
			input_right_before_sbox[index] = sbox(val, index)
		end
		input_right_after_sbox = input_right_before_sbox.join
		puts "Sbox:  #{input_right_after_sbox.scan(/.{4}/).join(' ')}" if options[:verbose]

		#P-Box(32bit --> 32bit)
		input_right_after_pbox = P.map{|i| input_right_after_sbox[i-1]}.join
		puts "P   : #{input_right_after_pbox.scan(/.{8}/).join(' ')}" if options[:verbose]
		
		# XOR with left input to get new right input (32bit-->32bit)
		input_right_after_xor_with_left = ""
		32.times do |i|
			input_right_after_xor_with_left += (input_left[i].to_i(2) ^ input_right_after_pbox[i].to_i(2)).to_s(2)
		end

		#Swap left and right
		input_left = input_right
		input_right = input_right_after_xor_with_left
		puts "L[i]: #{input_left.scan(/.{8}/).join(' ')}" if options[:verbose]
		puts "R[i]: #{input_right.scan(/.{8}/).join(' ')}" if options[:verbose]
	end

	#joining for output
	#before_output = input_left + input_right
	before_output = input_right + input_left
	puts "LR[16]  #{before_output.scan(/.{8}/).join(' ')}" if options[:verbose]

	#invert initial permutation
	output = INVERT_INITIAL_PERMUTATION.map{|i| before_output[i-1]}.join

	puts "Output: "  if options[:iteration]
	display(output,options[:format]) if options[:iteration]
	final_output << output
end
print "Final Output: " 
display(final_output,options[:format]) if options[:delimiter].nil?
display(final_output,options[:format],8,options[:delimiter]) if !options[:delimiter].nil?
