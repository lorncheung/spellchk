class Dictionary 
  def self.load_words 
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
end 
