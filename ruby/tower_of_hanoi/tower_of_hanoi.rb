#!/usr/bin/env ruby

# assume 3 poles 
MAX_POLES = 3
MAX_DISKS = 4

$count = 0;

def print_state(state)
	puts "COUNT: ##{$count}"
	$count += 1
	(0...MAX_DISKS).reverse_each {|level|
		MAX_POLES.times{|pole|
	        disk = 0 
	        disk = state[pole][level] unless state[pole][level].nil?
	        print "%#{MAX_DISKS}s|%-#{MAX_DISKS}s " % ['I'*disk,'I'*disk]
	    }
		puts
    }
	puts
end

def move (disks, from, to, state)
	# puts "Into Move (#{state.to_s})"
	
	moving_disk = disks.first
	above_disks = disks[1..-1]		#slice the first off
	
	if(above_disks.empty?)
		#single disk move
		puts "Move disk #{moving_disk} from #{from} to #{to}"
		state[to].push(state[from].pop)
		print_state(state)
		
	else
		#find a temp pole
		temp = [*0...MAX_POLES].select{|i| i!=from && i!=to}.first
		
		#move disks above it first, to temp pole
		move(above_disks, from, temp, state)
		
		#move the bottom disk
		puts "Move disk #{moving_disk} from #{from} to #{to}"
		state[to].push(state[from].pop)
		print_state(state)
		
		#move disks from temp pole to to-pole
		move(above_disks, temp, to, state)
	end
	
	# puts "Exit Move (#{state.to_s})"
end


# initialize program
# 3 poles, 3 disks 
state = {0=>[*1..MAX_DISKS].reverse!, 1=>[], 2=>[]}
print_state(state)
move(state[0], 0, MAX_POLES-1, state)

p state