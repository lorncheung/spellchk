#!/usr/bin/ruby 

require 'lib/String'
require 'lib/Dictionary'
require 'lib/Trie'
require 'benchmark' 

# Main function call
#
def main()
  # initialize 
  if ARGV[0] and ARGV[0].match(/(--help|-h)/)
    puts File.new('README',"r").read
    exit()
  end 
 # Benchmark.bm do |x|
 #   x.report("loading:") do 

      word_list = Dictionary.load_words_trie()

      while (true) do  
        #begin 
          suggestions = {}
          print "> "
          answer = STDIN.gets

          # check for bad input, nil or nonalpha first letter
          if answer.chars.first.nil? 
            puts "NO SUGGESTION" 
            next 
          end 
          
          answer.chomp! and answer.downcase!
          
          suggestions = word_list.match?(word_list.trie,answer,suggestions,answer,'')

          if suggestions.size > 0
            best = suggestions.sort{|a,b| b[1] <=> a[1]}.first.first 
            puts best + ":" + suggestions.inspect
          else 
            puts "NO SUGGESTION"
          end

        #rescue Exception => err
        #  puts err
        #  break
        #end
   #   end 
  #  end 
  end 
end 

main()
