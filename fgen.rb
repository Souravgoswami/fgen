#!/usr/bin/env ruby
require 'io/console'

def help
	puts <<EOF
Help:
	Hi, my name is font generator, also known as fgen.
	I am a funny, little program who generates a font of your choice on your terminal!

	Running me:
		Just run me as you run other programs.
			Example 1 (using the shell):
				chmod 777 fgen.rb
				./fgen.rb
			Example 2 (using the ruby interpreter):
				ruby fgen.rb

	Usage:
		1. After you got me running, I will ask you to choose a font style template. There are many.
		2. Select a template of your choice, and then start typing, I will show you what you typed.
		3. When done, press escape key or Ctrl + c or Ctrl + d to quit me.
		4. You can also pass arguments to me, I will show them but you need to confirm the style.
			Example 1:
				./fgen.rb give me a sweet font!
			Example 2:
				ruby fgen.rb show me a magic!

		I will handle the arguments after the fgen.rb part. I will also ask you for the style, as I told.

	Suggestion: You can also copy the text, and paste online. Thanks for using me!

		\xe3\x8b\xa1\x00
	Have a Good Day!
EOF
	exit!
end

help if ['-h', '--help'].include? ARGV[0]

begin
	def gen(font="\xf0\x9d\x90\x9a", ch)
		font, h = font.encode('utf-8'), {}
		('a'..'z').to_a.map do |c| h.merge! c => font ; font = font.next end ; h[ch]
	end

	fonts = ["\xf0\x9d\x93\xaa" ,"\xf0\x9d\x90\x9a", "\xf0\x9d\x9a\x8a", "\xf0\x9d\x96\xba",
		"\x61\xcc\xbd\xcd\x90\x00", "\x61\xcc\xbd\xcd\x91\x00", "\x61\xcc\xbd\xcd\x92\x00",
		"\x61\xcc\xbd\xcd\x93\x00", "\x61\xcc\xbd\xcd\x94\x00", "\x61\xcc\xbd\xcd\x95\x00",
		"\x61\xcc\xbd\xcd\x96\x00", "\x61\xcc\xbd\xcd\x97\x00", "\x61\xcc\xbd\xcd\x98\x00",
		"\x61\xcc\xbd\xcd\x99\x00", "\xf0\x9f\x85\x90", "\xf0\x9f\x85\xb0", "\xf0\x9f\x84\xb0",
		"\xf0\x9d\x94\x9e", "\xf0\x9d\x96\x86", "\x61\xcd\x80\x00", "\x61\xcd\x81\x00",
		"\x61\xcd\x82\x00", "\x61\xcd\x83\x00", "\x61\xcd\x84\x00", "\x61\xcd\x85\x00",
		"\x61\xcd\x86\x00", "\x61\xcd\x87\x00", "\x61\xcd\x88\x00", "\x61\xcd\x89\x00",
		"\x61\xcc\xba\x00", "\x61\xcc\xbb\x00", "\x61\xcc\xbc\x00", "\x61\xcc\xbd\x00",
		"\x61\xcc\xbe\x00", "\x61\xcc\xbf\x00", "\x61\xcc\x9f\x00", "\xf0\x9d\x95\x92",
		"\x61\xd2\x89\x00", "\x61\xcc\xb0\x00", "\x61\xcc\xb1\x00", "\x61\xcc\xb2\x00",
		"\x61\xcc\xb3\x00", "\x61\xcc\xb4\x00", "\x61\xcc\xb5\x00", "\x61\xcc\xb6\x00",
		"\x61\xcc\xb7\x00", "\x61\xcc\xb8\x00", "\x61\xcc\xb9\x00"
		]

	at_exit do
		puts "\n\t\xe3\x8b\xa1\x00"
		s = fonts.sample
		"have a good day".chars do |c| print c =~ /[a-z]/ ? gen(s, c) : c end ; puts
	end

	puts "The Available Styles are:\n\n"

	fonts.size.times do |count| print "\t#{count + 1} "
		('a'..'z').to_a.each do |c| print gen(fonts[count], c) end ; puts
	end

	print "\nSelect a Style(1 to #{fonts.size}): "
	choice = STDIN.gets.to_i
	exit! if choice > fonts.size + 1
	font, word = fonts[choice - 1], ''

	if ARGV.empty?
		puts "Start Typing!..."
		loop do
			w = STDIN.getch.downcase
			word.chop!.chop! if w == "\u007F"
			exit if ["\u0003", "\u0004", "\e"].include?(w)
			word += "\n" if w == "\r"
			word += "#{w =~ /[a-z]/ ? gen(font, w) : w }"
			print "\033[H\033[J#{word}"
		end
	else
		puts choice
		ARGV.each do |word| word.chars do |w| print w =~ /[a-z]/ ? gen(font, w) : w end end
	end
rescue Exception
	help
end
