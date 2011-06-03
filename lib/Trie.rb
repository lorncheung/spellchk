class Trie
  # modified from wikipedia simple ruby trie struct

  attr_accessor :trie

  def initialize()
    @trie = Hash.new()
  end

  def build(str) 
    node = @trie    
    str.each_char do |ch|
      cur = ch 
      prev_node = node
      node = node[cur]
      if node == nil 
        prev_node[cur] = Hash.new() 
        node = prev_node[cur]
      end
    end 
    node['__WORD__'] = str
  end

  def goto(str)
    node = @trie
    str.each_char do |ch|
      cur = ch
      node = node[cur]
      if node == nil
        return nil
      end
    end  
    return node 
  end 

  def find(str) 
    node = @trie
    str.each_char do |ch|
      cur = ch 
      node = node[cur]
      if node == nil 
        return false
      end
    end
    return node['__WORD__'] if node['__WORD__'] == str
  end

  def edits (node,str,results,depth) 
    if str.size == 0 && depth >= 0 && !node['__WORD__'].blank? 
      results[node['__WORD__']] = 1 # or score
    end 

    if depth >= 1 

    end 
  end 
  
  def best_match(arr)

  end 


  # TODO: 
  # track depth of word count to know when to stop on a word
  # track path to get to point 
  # recurse through variations until __WORD__ is reached or if nil is found, then we don't have a match
  #   return an array of matches

  def match?(trie, str, results = {})
    str = str.class == String ? str.split('') : str

    # base case if your string is empty, check if you're at word 
    if str.size == 0
      if trie and trie['__WORD__'] != nil
        puts " matches #{results['__WORD__']}"
        return results[trie['__WORD__']] = 1
      else 
        puts "no match" 
        return results 
      end 
    end 
    ch = str.shift

    # perfect match case
    
    if str.size >= 1  and trie[ch]
      print " #{ch}:p "
      match?(trie[ch], str, results) # str shifted already, check substr
    else
      # imperfect match case, check for variants
      if ch.vowel? and str.size >= 0
        # match vowels substitution
        %w{a e i o u}.each do |vowel|
          print "  #{ch}:v\n    #{vowel}"
          match?(trie[vowel],str,results)
        end 
      end
      
      if ch == str[0] 
        # match repeating letters
        print " #{ch}:c "
        match?(trie[ch],str,results)
      end 

      # matching done, if no matches return results 
    end 
    return results
  end 


    def matches?(str, depth, node = nil) 
      # traverse trough str and look for match in trie
      str = str.class == String ? str.downcase.split('') : str
      node = node || @trie # recursive or default full set
      i = 0
      last_ch = ""
      previous_node = nil
      is_repeating = false

      log = true 
      while (i < str.size and str.size > 0)
        return false if str.nil?
        ch = str[i]
        print ch if log
        cur = ch
        previous_node = node
        node = node[cur]
        if node == nil or ch.vowel? 
          # not a match
          if (ch == last_ch)
            if ch.vowel? 
              %w{a e i o u}.each do |vowel|
                if match = matches?(str[i+1,str.size],depth,previous_node[vowel])
                  return match 
                end 
              end 
            else 
              # repeating letter (consonant or vowel) 
              puts " matches repeating #{ch}" if log
            end 
            node = previous_node
            is_repeating = true
          elsif ch.vowel? and i <= str.size-1 
            puts " matched vowel #{ch}"
            %w{a e i o u}.each do |vowel|
              if match = matches?(str[i+1,str.size],previous_node[vowel])
                return match 
              end 
            end 
          else
            return false
          end 
        else 
          # exact match
          puts " matches exactly #{ch}" if log
          s_repeating = (last_ch == ch)
        end
        i += 1
        last_ch = ch
      end
      # done, no failures, we found a match 
      return node['__WORD__']
    end
  end
=begin
  def matches?(word)
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
=end 
