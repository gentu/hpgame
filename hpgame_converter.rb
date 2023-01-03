lines = File.readlines 'chinese_freq.txt'

#dict = Array.new {
#  Hash.new {
#    'Serial number',
#    'Character',
#    'Individual raw frequency',
#    'Cumulative frequency in percentile',
#    'Pinyin',
#    'English translation'
#  }
#}
@counter1 = Hash.new 0

def pronounce pinyin
  @counter1[pinyin.split(?/).size] +=1
  pinyin.tr! '0-9:', ''
  arr = pinyin.split ?/
  arr.uniq.join ' '
end

dict = lines.map do |line|
  line.strip!
  arr = line.split ?\t
  {
    'Serial number' => arr[0],
    'Character' => arr[1],
    'Individual raw frequency' => arr[2],
    'Cumulative frequency in percentile' => arr[3],
    'Pinyin' => pronounce(arr[4]||''),
    'English translation' => arr[5].nil? ? '' : arr[5]
  }
end

def game dict
  rand_chars = 5.times.map { dict[rand(154) + 1] }
  hanzi = pinyin = String.new
  rand_chars.each do |char|
    hanzi += char['Character']
    pinyin += char['Pinyin'].split.first
  end
  puts hanzi
  puts gets == pinyin ? 'yes' : pinyin
  exit
end

def game_save dict
  require 'yaml'
  hash = Hash.new
  dict.each do |char|
    hash[char['Character']] = {
      pinyin: char['Pinyin'].split.first,
      score: 0
    } if char['Pinyin'] != ''
  end
  #p array.first
  File.open('hpgame.yml', 'w') { |f| f.write hash.to_yaml }
  exit
end

game_save dict

counter2 = Hash.new 0
dict.each do |char|
  str = ( char['Character'] + ?\t +
          char['Pinyin'] + ?\t +
          char['Serial number'] + ?\t +
          char['English translation'] )
  puts str
  counter2[char['Pinyin'].split.size] +=1
end

p @counter1.sort.to_h
p counter2.sort.to_h
#puts dict.first 2
