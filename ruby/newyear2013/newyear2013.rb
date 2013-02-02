#!/usr/bin/env ruby
#encoding: utf-8

require 'curses'
include Curses

$width = 78
$height = 22
direction = :left
$delay = 0.05

def onsig(sig)
  close_screen
  exit sig
end

def display(word,x,y,direction)
	#Curses.setpos(10,10)
	#Curses.addstr('xyz')
	word.scan(/./).each do |c|
		if(x.between?(0,$width) and y.between?(0,$height))
			Curses.setpos(y, x)
  			Curses.addstr(c)
  		end
  		
  		if(direction==:left and x==$width)
  			direction = :down
  		elsif(direction==:up and y==$height)
  			direction = :left
  		elsif(direction==:right and x==0)
  			direction = :up
  		elsif(direction==:down and y==0)
  			direction = :right
		end

		case direction
			when :left
				x += 1
			when :right
				x -= 1
			when :down
				y -= 1
			when :up
				y += 1
		end
	end
end

def apple
	Curses.attron(color_pair(COLOR_RED)|A_NORMAL){
		Curses.setpos(($height/2),($width/2))
		Curses.addstr('Ó')
	}
end

# main #

=begin
#set trap for signal
for i in 1 .. 15  # SIGHUP .. SIGTERM
  if trap(i, "SIG_IGN") != 0 then  # 0 for SIG_IGN
    trap(i) {|sig| onsig(sig) }
  end
end
=end

Curses.init_screen
Curses.start_color
Curses.use_default_colors
#Curses.init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK) 
Curses.init_pair(COLOR_RED,COLOR_RED,COLOR_BLACK)
Curses.init_pair(COLOR_WHITE,COLOR_WHITE,COLOR_BLACK)
begin
	Curses.getch  # Wait until user presses some key.
	
	#left
	$width.downto(0).each do |x|
		y=$height
		Curses.clear
		apple
		display('Happy New Year 2013',x,y,:left)
		Curses.refresh
		sleep($delay)
	end

	#up
	$height.downto(0).each do |y|
		x=0
		Curses.clear
		apple
		display('Happy New Year 2013',x,y,:up)
		Curses.refresh
		sleep($delay)
	end

	#right
	0.upto($width).each do |x|
		y=0
		Curses.clear
		apple
		display('Happy New Year 2013',x,y,:right)
		Curses.refresh
		sleep($delay)
	end

	#down
	0.upto($height/2).each do |y|
		x=$width
		Curses.clear
		apple
		display('Happy New Year 2013',x,y,:down)
		Curses.refresh
		sleep($delay)
	end	

	#down
	$width.downto($width/2).each do |x|
		y=$height/2
		Curses.clear
		apple
		display('Happy New Year 2013',x,y,:left)
		Curses.refresh
		sleep($delay)
	end	

	#final
	Curses.clear
	Curses.attron(color_pair(COLOR_RED)|A_NORMAL){
		(0..$width).each do |x|
			(0..$height).each do |y|
				Curses.setpos(y,x)
				Curses.addch('+')
			end
		end
	}
	display('Happy New Year 2013',$width/2-7,$height/2,:left)
	display('Live Long & Prosper',$width/2-3,$height/2 + 2,:left)
	display('From Phitchayaphong Tantikul',$width/2,$height/2 + 4,:left)

	Curses.getch  # Wait until user presses some key.
ensure
  Curses.close_screen
end