#!/bin/ruby


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

LOG = false 
class String
  def lmatch(word)
    wordarr = word.chars.to_a
    selfarr = self.chars.to_a
    i,j = 0,0
    lastletter = ""
    while (i < selfarr.size)
      print selfarr[i] if LOG
      if wordarr[j].nil? and lastletter = selfarr[i]
        return true
        #return self[i,self.size].match(/#{word[j-1]}+/i) ? true : false
      else
        if selfarr[i].downcase == wordarr[j].downcase
          # OK, it's a match
          puts "  matched letter" if LOG
        else 
          # NOT A MATCH, but check exceptions
          if (i > 0 and selfarr[i].downcase == selfarr[i-1].downcase)
          #if selfarr[i].match(/^#{selfarr[i-1]}$/i) 
            # is the previous letter repeating?
            puts "  repeating consonant" if LOG
            j -= 1
          elsif selfarr[i].match(/[aeiou]/i) and wordarr[j].match(/[aeiou]/i)
            # is it a vowel?
            puts "  diff vowel" if LOG
          else
            puts " NOT MATCH" if LOG
            return false
          end 
        end 
        lastletter = selfarr[i].downcase
        i += 1
        j += 1
      end 
    end 
    if selfarr.size > i
      return false 
    else 
      return true
    end 
  end 
end 


#puts "cattt".lmatch("cat")
main()
