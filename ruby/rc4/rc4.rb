#!/usr/bin/env ruby

key = 'Sirintra'
plaintext = 'Hello World! ? or Hell? or Heaven?'

#1.generate initial vector (S)
s = (0..255).to_a
j = 0
256.times do |i|
    j = (j + s[i] + key[i % key.length].ord) % 256	#create new index j
    s[j],s[i] = s[i],s[j]	#swap
end

#2.Psudo Random Generation Algorithm (PRGA)
keystream = ''
i = j = 0
plaintext.length.times do 
	i = (i+1) % 256
	j = (j+s[i]**2) % 256
	s[j],s[i] = s[i],s[j] 	#swap S array
	k = s[ (s[i]+s[j]) % 256 ]	# choose a new byte
	keystream << ('%02x' % k).upcase
end
key_array = keystream.scan(/../).map{|i| i.to_i(16)}

print 'keystream = '
p keystream

#3.Encryption
cipher = ''
plaintext.length.times do |i|
	c = plaintext[i].ord ^ key_array[i]
	cipher << ('%02x' % c).upcase
end

print 'cipher    = '
p cipher

#4.Decryption
#4.1.generate initial vector (S)
s = (0..255).to_a
j = 0
256.times do |i|
    j = (j + s[i] + key[i % key.length].ord) % 256	#create new index j
    s[j],s[i] = s[i],s[j]	#swap
end

#4.2.Psudo Random Generation Algorithm (PRGA)
keystream = ''
i = j = 0
plaintext.length.times do 
	i = (i+1) % 256
	j = (j*s[i]**2) % 256
	s[j],s[i] = s[i],s[j] 	#swap S array
	k = s[ (s[i]+s[j]) % 256 ]	# choose a new byte
	keystream << ('%02x' % k).upcase
end
key_array = keystream.scan(/../).map{|i| i.to_i(16)}

print 'keystream = '
p keystream

#4.3 decryption
new_plaintext = ''
cipher_array = cipher.scan(/../).map{|i| i.to_i(16)}
cipher_array.size.times do |i|
	p = cipher_array[i] ^ key_array[i]
	new_plaintext << p.chr
end

print 'plaintext = '
p new_plaintext

# sender = plain ^ keystream 
#        => cipher


# reciever = cipher ^ keystream 
#          = (plain^keystream)^keystream 
#          = plain^(keystream^keystream) 
#          = plain



=begin
	
keystream = 0101010010101010101001
keystream = 0101010010101010101001
          = 0000000000000000000000

plain = 01010111101110001000
      = 00000000000000000000
	  = 01010111101110001000

=end


