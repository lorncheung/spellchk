#!/usr/bin/ruby 

require 'lib/String'
require 'lib/Dictionary'

# Main function call
def main()
  # initialize 
  word_list = Dictionary.load_words()
  display_alts = ARGV[0] == "-a"

  while (true) do  
    begin 
      # setup prompt and containers  
      suggestion = { :word => nil, :rank => 0}
      alts = [] if display_alts
      print "> "
      answer = STDIN.gets

      # check for bad input, nil or nonalpha first letter
      if answer.chars.first.nil? or word_list[answer.chars.first.downcase].nil?
        puts "NO SUGGESTION" 
        next 
      end 

      answer.chomp! 

      # retrieve letter specific word list 
      word_list[answer.chars.first.downcase].each do |word|
        if answer.downcase == word.downcase
          suggestion = {:rank =>  word*4, :word => word}
          break 
        else  
          if rank = answer.matches?(word)
            if suggestion[:rank] < rank
              alts << suggestion[:word] if display_alts and suggestion[:word]
              suggestion = {:rank => rank, :word => word}
            else 
              alts << word if display_alts
            end 
          end
        end
      end 

      # return response to prompt
      if suggestion[:word]
        puts suggestion[:word]
        puts " other matches: #{alts.join(', ')}" if display_alts and alts.size > 0
      else
        puts "NO SUGGESTION FOR #{answer}"
      end 
    rescue Exception 
      break
    end
  end 
end 

main()
