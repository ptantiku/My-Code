#!/usr/bin/env ruby

# includes Xdo package
require 'xdo/keyboard'
require 'xdo/mouse'
require 'xdo/xwindow'

# search for window id using title name
win_id = XDo::XWindow.search("Slalom Canoe 2012").last 

# Uncomment to bring the window up (I don't need to bring it up)
# window = XDo::XWindow.new(win_id) # create window object (this does not create an actual new window)
# window.unfocus  #make sure the window is not focus before call .activate
# window.activate #bring the window up

# loop 1000 times to send left and right to the window
1000.times do
	XDo::Keyboard.char("Left",win_id);
	XDo::Keyboard.char("Right",win_id);
end