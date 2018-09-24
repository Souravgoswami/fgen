#!/usr/bin/env ruby
require 'io/console'

def gen(font="\xf0\x9d\x90\x9a", char)
	font, h = font.encode('utf-8'), {}
	('a'..'z').to_a.each do |c| h.merge! ({c => font}) ; font = font.next end ; h[char]
end

fonts = ["\xf0\x9d\x93\xaa" ,"\xf0\x9d\x90\x9a", "\xf0\x9d\x9a\x8a", "\xf0\x9d\x96\xba",
	"\xf0\x9f\x85\x90", "\xf0\x9f\x85\xb0", "\xf0\x9f\x84\xb0"]

print "Available Fonts:\n"

fonts.size.times do |count|
	print "#{count + 1}"
	('a'..'z').to_a.each do |c| print gen(fonts[count], c) end ; puts
end

print "Select: "
choice = gets.to_i
exit! if choice > fonts.size + 1
font, word = fonts[choice - 1], ''

print "Start Typing: \n"
loop do
	w = STDIN.getch.downcase
	word.chop!.chop! if w == "\u007F"
	exit if ["\u0003", "\u0004", "\e"].include?(w)
	word += "#{w =~ /[a-z]/ ? gen(font, w) : w }"
	print "\033[H\033[J#{word}"
end
