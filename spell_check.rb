#!/usr/bin/ruby 

require 'lib/String'
require 'lib/Dictionary'
require 'lib/Trie'
require 'optparse'
require 'benchmark' 

# Main function call
#
def main()
  # initialize 
  options = {}

  OptionParser.new do |opts|
    opts.banner = "Usage: ./spell_check.rb [options]"
    opts.on("-h", "--help") do |h|
      puts File.new('README',"r").read
      exit
    end 
    opts.on("-m", "--matches") do |m|
      options[:include_matches] = true
    end 
  end.parse!

  word_list = Dictionary.load_words_into_trie()

  while (true) do  
    begin 
      suggestions = {}
      print "> "
      answer = STDIN.gets

      # check for bad input, nil or nonalpha first letter
      if answer.chars.first.nil? 
        puts "NO SUGGESTION" 
        next 
      end 

      answer.chomp! 

      suggestions = answer.matches?(word_list.root,answer)

      if suggestions.size > 0
        best = suggestions.sort{|a,b| b[1] <=> a[1]}.first.first 
        best += ":" + suggestions.inspect if options[:include_matches]
        puts best 
      else 
        puts "NO SUGGESTION"
      end

    rescue Exception => err
      break
    end
  end
end 

main()
