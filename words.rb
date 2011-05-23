class String
  def lmatch(word)
    log = false 
    wordarr = word.chars.to_a
    selfarr = self.chars.to_a
    i,j = 0,0
    lastletter = ""
    puts word if log
    # base case, return the obvious
    return true if word.downcase == self.downcase

    # loop through each letter of word and match against corresponding letter in dictionary word
    # stop when either word reaches the end
    while (i < selfarr.size and j < wordarr.size)
      print " #{selfarr[i]}" if log
      if selfarr[i].downcase == wordarr[j].downcase
        # OK, it's a match
        puts "  matched letter" if log
      else 
        # NOT A MATCH, but check exceptions
        if (i > 0 and selfarr[i].downcase == selfarr[i-1].downcase)
          #if selfarr[i].match(/^#{selfarr[i-1]}$/i) 
          # is the previous letter repeating?
          puts "  repeating consonant" if log
          j -= 1
        elsif selfarr[i].match(/[aeiou]/i) and wordarr[j].match(/[aeiou]/i)
          # is it a vowel?
          puts "  diff vowel" if log
        else
          puts " NOT MATCH" if log
          return false
        end 
      end 
      lastletter = selfarr[i].downcase
      i += 1
      j += 1
    end 

    if i == selfarr.size 
      # TODO if end of self, return true only if end of dictionary word
      #puts "reached end of self: #{self}(#{self.size},#{i}), dict: #{word}(#{word.size})(#{j}) may be greedy"
      return j == wordarr.size
    else 
      #puts "reached end of dict: #{word}(#{word.size},#{j}), self: #{self}(#{self.size})(#{i}) may be greedy"
      while (i < selfarr.size)
        if selfarr[i] != lastletter
          return false
        end 
        i += 1
      end
      return true
    end 
  end 
end 

