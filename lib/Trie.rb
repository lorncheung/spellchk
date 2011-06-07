class Trie
  require 'lib/String'
  require 'lib/Dictionary'

  VOWELS = %w{a e i o u}

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

  def best_match(arr)

  end 


  # TODO: 
  # track depth of word count to know when to stop on a word
  # track path to get to point 
  # recurse through variations until __WORD__ is reached or if nil is found, then we don't have a match
  #   return an array of matches
  def testy(trie,str,prefix,depth,results)
    str = str.class == String ? str.split('') : str
    trie = trie.trie if trie.class == Trie
    rewind_str = str.join('')
    puts "str: #{str.join('')}"

    # base case if your string is empty, check if you're at word 
    if str.size == 0
      if trie and trie['__WORD__'] != nil
        puts "\tmatches #{trie['__WORD__']}:"
        results[trie['__WORD__']] = 1
      end 
      trie = goto(rewind_str)
    else 
      if depth >= 0
        ch = str.first
        if trie[ch] 
          # check for perfect match
          puts "  #{ch}:PERFECT, matching key:#{ch} prefix:#{prefix+ch}:"
          testy(trie[ch],str[1,str.size],prefix+ch,depth-1,results) # traverse
          #puts "TRIE keyes after processing : #{trie.keys}" if trie
        end 

        if ch.vowel? 
          %w{a e i o u}.each do |vowel|
            #wrd = vowel + str.join('')
            puts "  #{ch}:VOWEL, replacing key:#{vowel} str:#{str} - pre:#{prefix}"
            testy(trie[vowel],str[1,str.size],prefix+vowel,depth-1,results) # replace vowel and try again
          end 
        end 
        
        if prefix.size > 1 and ch == prefix[prefix.size-1].chr
          # check for repeating letter 
          puts "  #{ch}:REPEAT, matching letter #{ch} prefix:#{prefix}:"
          testy(trie,str,prefix+ch,depth-1,results) # skip next letter
          #puts "TRIE keyes after processing : #{trie.keys}" if trie
        end 
      end 
    end 
    return results
  end 

  def match?(trie, str, results, orig, last, score = 0)
    log = false 
    str = str.class == String ? str.split('') : str
    trie = trie.trie if trie.class == Trie
    puts "str: #{str.join('')} orig: #{orig}" if log

    # base case if your string is empty, check if you're at word 
    if str.size == 0
      if trie and trie['__WORD__'] != nil 
        puts "\tmatches str:#{str} : #{trie['__WORD__']}:" if log
        score = orig.size*6 if trie['__WORD__'] == orig
        results[trie['__WORD__']] = score
      end 
    else

      ch = str.shift

      if trie[ch] 
        # check for perfect match
        puts "  #{ch}:100%, matching key:#{ch} str:#{str.to_s}:" if log
        match?(trie[ch],str.clone,results,orig,ch,score+4) # traverse
      end 
      
      if ch == last 
        # check for repeating letter 
        puts "  #{ch}:REPT, matching letter #{ch} and #{str[0]} str:#{str.to_s}:" if log
        match?(trie,str.clone,results,orig,ch,score+2) # skip next letter
      end 
        
      if ch.vowel? 
        # check vowel
        VOWELS.each do |vowel|
          if trie[vowel] and ch != vowel
            score += (homonym_vowels?(vowel,ch) ? 2 : 1)
            puts "  #{ch}:VOWL, trying #{vowel} on str:#{str.to_s}:" if log
            match?(trie[vowel],str.clone,results,orig,ch,score) # traverse valid vowels
          end 
        end 
      end 
    end 
    return results
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

end
