#!/usr/bin/ruby 

require 'lib/String'
require 'lib/Dictionary'
require 'benchmark'

# Main function call
#
def main()
  # initialize 
  if ARGV[0] 
    if ARGV[0].match(/(--help|-h)/)
      puts File.new('README',"r").read
      exit()
    end 
  end 
  Benchmark.bm do |x|
    x.report("loading:") do 
      word_list = Dictionary.load_words()
      while (true) do  
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
              # shortcut exact matches
              suggestion = {:rank =>  word*6, :word => word}
              break 
            elsif rank = answer.old_matches?(word) and suggestion[:rank] < rank
              suggestion = {:rank => rank, :word => word} 
            else 
              # do nothing, no matched
            end
          end 

          # print response 
          puts suggestion[:word] ? suggestion[:word] : "NO SUGGESTION" 

      end 
    end 
  end 
end 

main()
