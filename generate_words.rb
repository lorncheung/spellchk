#!/usr/bin/ruby 

require 'lib/Dictionary'
require 'lib/String'

# generate misspelled words based on the dict word list 

word_list = Dictionary.load_words()

("a".."z").each do |letter|
  5.times do 
    rand_word = word_list[letter][rand(word_list[letter].size)]
    puts rand_word
    puts rand_word.scramble!
  end 
end 

