#!/usr/bin/ruby 

require 'lib/String'
require 'lib/Dictionary'

# Main function call
def main()
  # initialize 
  word_list = Dictionary.load_words()
  display_alts = ARGV[0] == "-a"

  while (true) do  
    # setup prompt and containers  
    suggestion = { :word => nil, :rank => 0}
    alts = []
    print "> "
    answer = STDIN.gets
    answer.chomp! 

    # check for bad input, nil or nonalpha first letter
    if answer.chars.first.nil? or word_list[answer.chars.first.downcase].nil?
      puts "NO SUGGESTION" 
      next 
    end 

    # retrieve letter specific word list 
    word_list[answer.chars.first.downcase].each do |word|
      if rank = answer.matches?(word)
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
