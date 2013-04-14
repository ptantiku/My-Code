#!/usr/bin/ruby

#Implementing Luhn Algorithm for creating checksum and checking checksum digit
#by Ptantiku

#creating checksum
id='7992739871'
id_array = id.scan(/./).map{|c| c.to_i}
p id_array
sum = 0
id_array.size.times{|i|
	print "#{i}: #{id_array[i]} --> "
	if i%2 == 0
		sum+=id_array[i]
	else
		id_array[i]*=2
		tens = id_array[i]/10
		digit = id_array[i]%10
		sum+= tens+digit
	end
	puts sum
}
checksum = 10 - (sum%10)
puts "checksum = #{checksum}"

full_id = id+checksum.to_s
puts "Full ID = #{full_id}"

#checking checksum digit
id_array = full_id.scan(/./).map{|c| c.to_i}
sum = 0
id_array.size.times{|i|
	if i%2 == 0
		sum+=id_array[i]
	else
		id_array[i]*=2
		tens = id_array[i]/10
		digit = id_array[i]%10
		sum+= tens+digit
	end
}
if sum%10 == 0
	puts "Checksum is correct"
else
	puts "Checksum is wrong"
end