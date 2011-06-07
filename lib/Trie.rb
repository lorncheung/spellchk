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

  def matches?(trie, str, orig, last, score = 0)
    results = {}
    
    str = str.class == String ? str.split('') : str
    trie = trie.trie if trie.class == Trie

    # base case if your string is empty, check if you're at word 
    if str.size == 0
      if trie and trie['__WORD__'] != nil 
        # count exact matches as instant match 
        score = orig.size*10 if trie['__WORD__'] == orig
        results[trie['__WORD__']] = score
      else 
        # do nothing, no match
      end 
    else
      ch = str.shift

      # check for perfect match
      if trie[ch]  
        # traverse
        results.merge!(matches?(trie[ch],str.clone,orig,ch,score+4)) 
      end 
      
      # check for repeating letter 
      if ch == last  
        # skip next letter, don't advance yet
        results.merge!(matches?(trie,str.clone,orig,ch,score+2)) 
      end 
        
      # check vowel
      if ch.vowel? 
        VOWELS.each do |vowel|
          if trie[vowel] and ch != vowel # don't count same vowel
            scr = (homonym_vowels?(vowel,ch) ? 2 : 1)

            # traverse valid vowels
            results.merge!(matches?(trie[vowel],str.clone,orig,ch,score+scr)) 
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
