class String

  #  Given a word (dictionary word), matches? will return 
  #   1) a numeric score rank (highest being exact match 5 x # of letters)
  #   2) false for no match 
  #  
  #   The class of spelling mistakes matches? corrects is as follows:
  #
  #     Case (upper/lower) errors: "inSIDE" => "inside"
  #     Repeated letters: "jjoobbb" => "job"
  #     Incorrect vowels: "weke" => "wake"
  #
  def matches?(word)
    # convert strings to string arrays
    word_arr = word.chars.to_a
    self_arr = self.chars.to_a
    #word_arr = word.scan(/./)
    #self_arr = self.scan(/./)

    i,j,score = 0,0,0

    lastletter = ""
    is_repeating = false

    # base case, return the obvious
    return 5*self.size if word.downcase == self.downcase

    log = false 
   # word.match(/footmaker/)
    puts word if log
    # loop through each letter of word and match against the letter in dictionary word
    # if letter match found, adjust score and increment/decrement counters until end of 
    # string
    while (i < self_arr.size and j < word_arr.size)
      print self_arr[i] if log
      self_char = self_arr[i].downcase
      word_char = word_arr[j].downcase 

      if self_char == word_char 
        # exact match
        puts "  exact match" if log
        score += 4
        is_repeating = lastletter == self_char
      else 
        # check for spelling exceptions
        if (i > 0 and self_char == self_arr[i-1].downcase)
          # repeating consonant 
          puts "  repeating consonant" if log
          score += 2
          j -= 1 # shift index back on dict word 
          is_repeating = true
        elsif self_char.vowel? and word_char.vowel?
          # diff vowel 
          puts "  diff vowel" if log
          score += 1
          is_repeating = lastletter == self_char
        elsif lastletter.vowel? and word_char.vowel?
          puts "  diff vowel but lastletter also vowel" if log
          i -= 1
        elsif self_char.vowel? and lastletter.vowel? and is_repeating 
          puts "  diff vowel but lastletter repeats" if log
          j -= 1
        else
          puts "=>NOT MATCH #{is_repeating}" if log
          return false
        end 
      end 
      # adjust counters 
      lastletter = self_char
      i += 1 
      j += 1
    end 

    # we're done scanning, check for end cases
    if i == self_arr.size 
      # self stopped first, if dict word ends too, return score 
      return j == word_arr.size ? score : false 
    else 
      # dict word stopped first, look for repeating letters at the end
      while (i < self_arr.size)
        return false if self_arr[i].downcase != lastletter
        i += 1
      end
      return score # all trailing letters match
    end 
  end 

  #   scramble! returns a scrambled version of the string transformed 3 possible ways
  #
  #   1) adding repeating letters
  #   2) swapping out vowel with a random vowel 
  #   3) swap the case of the letter 
  #   4) preserve existing letter 
  #
  def scramble!
    self_arr = self.chars.to_a
    ''.tap do |word|
      self_arr.each_with_index do |letter,i|
        case %w{repeating vowels capitalize}[rand(3)]
        when "repeating"
          word << letter*(rand(2)+1) # up to 3 consecutive
        when "vowels"
          #if i > 0 and !self_arr[i-1].match(/#{letter}/i) and letter.vowel?
          if letter.vowel? 
            # swap only if non-consecutive
            word << %w{a e i o u}[rand(5)]
          else 
            word << letter
          end 
        when "capitalize" 
          word << letter.swapcase
        else 
          word << letter
        end 
      end 
    end 
  end 


  # Helper methods 
  #   
  def vowel? 
    return (self.size == 1 and self.match(/[aeiou]/i))
  end 

end 

