#!/usr/bin/ruby

# for digit #1..12
id=[]
id << Random.rand(1...10)
(2..12).each do
	id << Random.rand(10)
end

# for testing
# id = "399612946255".scan(/./).map{|i| i.to_i} # output: 3996129462553

# last digit (check sum)
x = 0
13.downto(2).each do |i|
	x += id[13-i]*i
end
x = x %11
id << ((x <= 1)? 1-x : 11-x)

# print the result
puts id.join

