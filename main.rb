#!/usr/bin/ruby 

require 'words'
class String
  def matches?(word, log = false)
    # convert strings to string arrays
    word_arr = word.chars.to_a
    self_arr = self.chars.to_a

    i,j,score = 0,0,0

    lastletter = ""

    puts word if log 

    # base case, return the obvious
    return 4*self.size if word.downcase == self.downcase

    # loop through each letter of word and match against the letter in dictionary word
    # if match found, adjust score and increment/decrement counters 
    while (i < self_arr.size and j < word_arr.size)
      if self_arr[i].downcase == word_arr[j].downcase
        # OK, it's a match
        score += 4
      else 
        # NOT A MATCH, but check exceptions
        if (i > 0 and self_arr[i].downcase == self_arr[i-1].downcase)
          # it's a repeating letter
          puts "  repeating consonant" if log
          score += 2
          j -= 1 # don't move index on word since self is repeating
        elsif self_arr[i].match(/[aeiou]/i) and word_arr[j].match(/[aeiou]/i)
          # it's a vowel
          score += 1
          puts "  diff vowel" if log
        else
          # no match
          puts " NOT MATCH" if log
          return false
        end 
      end 
      # adjust counters 
      lastletter = self_arr[i].downcase
      i += 1 
      j += 1
    end 

    if i == self_arr.size 
      # self stopped first, if dict word had ended too, return match other false
      
      return j == word_arr.size ? score : false 

    else 
      # dict word stopped first, look for repeating letters at the tail" 
      while (i < self_arr.size)
        return false if self_arr[i] != lastletter
        i += 1
      end
      # all letters match, return score
      return score
    end 
  end 
end 


# NOTES: 

def load_words 
  file = File.new("/usr/share/dict/words", "r")
  
  word_list = {} # store in an alpha hash for faster lookup
  
  while (word = file.gets) 
    word.chomp!
    first = word.chars.first
    if first.match(/[aeiou]/i) 
      # store word that starts with a vowel in each vowel since it's a potential word candidate
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
