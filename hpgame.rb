#!/usr/bin/ruby
require 'yaml'

hanzi_file = 'hpgame.yml'

CHARS = 2

file = YAML::load_file hanzi_file
size = Integer(ARGV[0]||file.size)
@dict = file.first size
@dict.shuffle! #randomize array

at_exit do
  File.open(hanzi_file, 'w') { |f| f.write file.to_yaml }
  puts 'Scores saved successful!'
end

def clear
  puts "\e[H\e[2J"
end

def continue
  puts 'Press any key to continue'
  STDIN.getc
  clear
end

def game
  chars = @dict.sort_by{|k,v| [v[:score].to_i, -v[:mistake].to_i]}.first(CHARS).shuffle.to_h
  hanzi = chars.keys
  pinyin = chars.map {|k,v| v[:pinyin]}
  puts hanzi.join #show string with hanzi
  input = STDIN.gets.split
  exit if input.first == 'exit'
  CHARS.times do |count|
    if input[count] == pinyin[count]
      chars[hanzi[count]][:score] += 1
    else
      begin
        puts "#{hanzi[count]} is #{pinyin[count].upcase} and not #{input[count].upcase}"
      rescue
        puts "#{hanzi[count]} is #{pinyin[count].upcase}"
      end
      chars[hanzi[count]][:score] -= 2
      chars[hanzi[count]][:mistake] += 1
    end
  end
  chars
#  puts (STDIN.gets.chomp == pinyin.join(' ')) ? 'yes' : pinyin.join(' ')
end

clear
loop { file.merge game; continue }
