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

  word_list = Dictionary.load_words_trie

  while (true) do  
    begin 
      print "> "
      answer = STDIN.gets
      answer.chomp! 
      answer.downcase! 

      results = {}
      if word_list.match?(word_list.trie, answer, results)
        puts results.keys.join(', ')
      else 
        puts "NO SUGGESTION"
      end

    rescue Exception => err
      break
    end
  end 
end 

main()
