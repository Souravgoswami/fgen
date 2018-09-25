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

		I will handle the arguments (fgen <your texts>). I will also ask you for a style.

	Suggestion: You can also copy the text, and paste online. Thanks for using me!

		 \033[38;5;6m\xe3\x8b\xa1\x00
	\033[38;5;6mHave a Good Day!
EOF
	exit! 0
end
help if ['-h', '--help'].include? ARGV[0]

begin
	gen = ->(font, ch) do font, h = font.encode('utf-8'), {}
				('a'..'z').map do |c| h[c] = font ; font = font.succ end ; h[ch]
			end

	fonts = ["\xf0\x9d\x93\xaa" ,"\xf0\x9d\x90\x9a", "\xf0\x9d\x9a\x8a", "\xf0\x9d\x96\xba", "\x61\xcc\xbd\xcd\x90", "\x61\xcc\xbd\xcd\x91",
			"\x61\xcc\xbd\xcd\x92", "\x61\xcc\xbd\xcd\x93", "\x61\xcc\xbd\xcd\x94", "\x61\xcc\xbd\xcd\x95", "\x61\xcc\xbd\xcd\x96",
			"\x61\xcc\xbd\xcd\x97", "\x61\xcc\xbd\xcd\x98", "\x61\xcc\xbd\xcd\x99", "\xf0\x9f\x85\x90", "\xf0\x9f\x85\xb0", "\xf0\x9f\x84\xb0",
			"\xf0\x9d\x94\x9e", "\xf0\x9d\x96\x86", "\x61\xcd\x80", "\x61\xcd\x81", "\x61\xcd\x82", "\x61\xcd\x83", "\x61\xcd\x84", "\x61\xcd\x85",
			"\x61\xcd\x86", "\x61\xcd\x87", "\x61\xcd\x88", "\x61\xcd\x89", "\x61\xcc\xba", "\x61\xcc\xbb", "\x61\xcc\xbc", "\x61\xcc\xbd", "\x61\xcc\xbe",
			"\x61\xcc\xbf", "\x61\xcc\x9f", "\xf0\x9d\x95\x92", "\x61\xd2\x89", "\x61\xcc\xb0", "\x61\xcc\xb1", "\x61\xcc\xb2", "\x61\xcc\xb3", "\x61\xcc\xb4",
			"\x61\xcc\xb5", "\x61\xcc\xb6", "\x61\xcc\xb7", "\x61\xcc\xb8", "\x61\xcc\xb9" ]
	at_exit do
		puts "\n\t\033[38;5;#{rand(0..255)}m\xe3\x8b\xa1\x00"
		s, greet = fonts.sample, ['have a good day', 'bye!', 'see you!', 'take care!'].sample
		greet.chars do |c| print c =~ /[a-z]/ ? gen.call(s, c) : c end ; puts
	end

	puts "The Available Styles are:\n\n"
	fonts.size.times do |count| print "\t#{count + 1} "
		('a'..'z').map do |c| print gen.call(fonts[count], c) end ; puts
	end

	print "\nSelect any Style(from 1 to #{fonts.size}): "
	choice = STDIN.gets.to_i
	exit! 0 if choice > fonts.size + 1 or choice < 1
	font, word = fonts[choice - 1], ''

	if ARGV.empty?
		puts "Start Typing!..."
		loop do
			w = STDIN.getch.downcase
			word.chop!.chop! if w == "\u007F"
			exit 0 if ["\u0003", "\u0004", "\e"].include?(w)
			word += "\n" if w == "\r"
			word += "#{w =~ /[a-z]/ ? gen.call(font, w) : w }"
			print "\033[H\033[J#{word}"
		end
	else ARGV.each do |word| word.chars do |w| print w =~ /[a-z]/ ? gen.call(font, w) : w end end
	end
rescue Exception
end
