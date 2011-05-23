#!/usr/bin/ruby 

require 'words'

# NOTES: 
# => read word list from file and intelligently store in an alpha hash for faster than o(n) lookup
# => store word that starts with a vowel in each vowel key since it's a potential word candidate

def load_words 
  file = File.new("/usr/share/dict/words", "r")
  word_list = {}
  
  while (word = file.gets) 
    word.chomp!
    first = word.chars.first
    if first.match(/[aeiou]/i) 
      %w{a e i o u}.each do |vowel|
        word_list[vowel] ||= []
        word_list[vowel] << word 
      end 
    else 
      word_list[first] ||= []
      word_list[first] << word 
    end 
  end 
  
  return word_list 

end 

# Main function call
def main()
  # initialize 
  word_list = load_words()
  display_alts = ARGV[0] == "-a"

  while (true) do  
    # setup prompt and containers  
    suggestion = { :word => nil, :rank => 0}
    alts = []
    print "> "
    answer = STDIN.gets
    exit(0) if answer.nil?
    answer.chomp! 

    # retrieve letter specific word list 
    word_list[answer.chars.first.downcase].each do |word|
      if rank = answer.lmatch(word)
        if suggestion[:rank] < rank
          # if match is of a higher rank than predecessor, move it to alt list and update
          alts << suggestion[:word] unless suggestion[:word].nil?
          suggestion[:rank] = rank
          suggestion[:word] = word
        else 
          alts << word # rank not higher, sorry, store in alt
        end 
      end
    end 

    # return response to prompt
    if suggestion[:word]
      puts suggestion[:word]
      puts " alt matches: #{alts.join(', ')}" if display_alts
    else
      puts "NO SUGGESTION"
    end 
  end 
end 

main()
