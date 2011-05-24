#!/usr/bin/ruby 

require 'lib/String'
require 'lib/Dictionary'
require 'benchmark' 

# Main function call
def main()
  # initialize 
  word_list = Dictionary.load_words()

  Benchmark.bmbm do |x|
  x.report("benchmark:\n") do 
  while (true) do  
    begin 
      suggestion = { :word => nil, :rank => 0}
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
              suggestion = {:rank => rank, :word => word}
            end 
          end
        end
      end 

      # return response to prompt
      if suggestion[:word]
        puts suggestion[:word]
      else
        puts "NO SUGGESTION FOR #{answer}"
      end 
    rescue Exception => err
      break
    end
  end 
  end 
  end 
end 

main()
