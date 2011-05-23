#!/usr/bin/ruby 

require 'words'

# NOTES: 
#
# Assumptions :
#   unless the first letter is a vowel, you can narrow your search down to just words with the 
#   same first letter. 
#
#   if the first letter is a vowel, match aeiou cases
#
#   incorrect vowels:

def init 
  file = File.new("/usr/share/dict/words", "r")
  wordlist = {}
  
  while (word = file.gets) 
    word.chomp!
    first = word.chars.first
    if first.match(/[aeiou]/i) 
      # puts "vowel word: #{word}"
      %w{a e i o u}.each do |vowel|
        wordlist[vowel] ||= []
        wordlist[vowel] << word 
      end 
    else 
      # puts "normal word: #{word}"
      wordlist[first] ||= []
      wordlist[first] << word 
    end 
  end 
  
  return wordlist 

end 

def main()
  wordlist = init()
  while (true) do  
    print "> "
    answer = STDIN.gets
    exit(0) if answer.nil?
    answer.chomp! 

    refinedlist = wordlist[answer.chars.first.downcase]
    refinedlist.each do |word|
      if answer.lmatch(word)
        puts " SUGGESTING #{word}"
      end
    end 
  end 
end 

main()
