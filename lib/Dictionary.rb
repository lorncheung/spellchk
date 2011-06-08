require 'lib/String'

class Dictionary 
 
  def self.load_words_into_trie
    file = File.new("/usr/share/dict/words", "r")
 
    word_list = Trie.new # store in an prefix trie/hash for faster lookup

    while (word = file.gets) 
      word.chomp!
      word.downcase! 
      word_list.build(word)
    end 

    return word_list
  end 
  
  
  # DEPRECATED, use load_words_into_trie
  #
  def self.load_words 
    file = File.new("/usr/share/dict/words", "r")

    word_list = {} # store in an alpha hash for faster lookup

    while (word = file.gets) 
      word.chomp!
      word.downcase!
      first = word.chars.first.downcase
      if first.vowel?
        # store word that starts with a vowel in each vowel since it's a potential word candidate
        String::VOWELS.each do |vowel|
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

end 


