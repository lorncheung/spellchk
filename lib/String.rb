require 'lib/Trie'
class String

  VOWELS = %w{a e i o u}

  def matches?(node, str, last_char = '', score = 0)
    matches = {}
    str = str.class == String ? str.split('') : str
    node = node.node if node.class == Trie

    # base case if your string is empty, check if you're at word 
    if str.size == 0
      if node and node['__WORD__'] != nil 
        # count exact matches as instant match 
        score = self.size*10 if node['__WORD__'] == self
        matches[node['__WORD__']] = score
      else 
        # do nothing, no match
      end 
    else
      char = str.shift 

      # check for perfect match
      if node[char]  
        # next character node 
        matches.merge!(self.matches?(node[char],str.clone,char,score+4)) 
      end
      
      # check for repeating letter 
      if char == last_char
        # move to the next letter, don't advance node yet
        matches.merge!(self.matches?(node,str.clone,char,score+2)) 
      end 
        
      # check vowel
      if char.vowel? 
        VOWELS.each do |vowel|
          if node[vowel] and char != vowel # don't traverse same vowel node
            scr = (homonym_vowels?(vowel,char) ? 2 : 1)

            # advance along vowel nodes
            matches.merge!(self.matches?(node[vowel],str.clone,char,score+scr)) 
          end 
        end 
      end 
    end 
    return matches
  end 


  def vowel?(v) 
    return (v.size == 1 and v.match(/[aeiou]/i))
  end 

  #
  # do vowels sound the similar? 
  #
  def homonym_vowels?(v1,v2) 

    pairs = [['a','e'],['e','i'],['o','u'],['o','e']]
    [v1,v2].map(&:downcase!)

    return pairs.inject(false){ |bool,vowels| bool ||= (vowels.member?(v1) and vowels.member?(v2))}
  end 











  #  DEPRECATED
  #
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
  def old_matches?(word)
    # convert strings to string arrays using scan instead of String.chars.to_a 
    # since it might not be defined in 1.8.6, otherwise would be slightly faster
    word_arr = word.scan(/./) 
    self_arr = self.scan(/./)

    i,j,score = 0,0,0
    lastletter = ""
    is_repeating = false

    # base case, return the obvious
    return 6*self.size if word.downcase == self.downcase

    while (i < self_arr.size and j < word_arr.size)
      self_char = self_arr[i].downcase
      word_char = word_arr[j].downcase 

      if self_char == word_char 
        # exact match
        score += 4
        is_repeating = lastletter == self_char
      else 
        # check for spelling exceptions
        if (i > 0 and self_char == self_arr[i-1].downcase)
          # repeating consonant 
          score += 3
          j -= 1 # shift index back on dict word 
          is_repeating = true
        elsif self_char.vowel? and word_char.vowel?
          # diff vowel 
          is_repeating = lastletter == self_char
          score += 2
        elsif lastletter.vowel? and word_char.vowel?
          # diff vowel but last letter also vowel
          i -= 1
          score += 1
        elsif self_char.vowel? and lastletter.vowel? and is_repeating 
          # diff vowel but last letter is repeating vowel
          j -= 1
          score += 1
        else
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
      # dict word stopped first, iterate until the end of self
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
            word << VOWELS[rand(5)]
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

  def vowel? 
    return (self.size == 1 and self.match(/[aeiou]/i))
  end 

end 

