class Dictionary 
  def self.load_words 
    file = File.new("/usr/share/dict/words", "r")

    word_list = {} # store in an alpha hash for faster lookup

    while (word = file.gets) 
      word.chomp!
      word.downcase!
      first = word.chars.first.downcase
      if first.match(/[aeiou]/) 
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

  def self.load_words_trie
    file = File.new("/usr/share/dict/words", "r")

    word_list = Trie.new # store in an alpha hash for faster lookup

    while (word = file.gets) 
      word.chomp!
      word.downcase!
      word_list.build(word)
    end 
    return word_list
  end 
end 

def insert_string(str_arr)
  if str_arr.size == 0 or str_arr.nil?
    puts " at the end" 
    return {} 
  else
    puts " puts #{str_arr.to_s}" 
    Hash.new[str_arr.shift] = insert_string(str_arr)
  end 
end 

class NestedHash < Hash
def get_all_values_nested(nested_hash={}) 
  nested_hash.each_pair do |k,v|
    case v
      when String, Fixnum then @all_values << v 
      when Hash then get_all_values_nested(v)
      else raise ArgumentError, "Unhandled type #{v.class}"
    end
  end

  return @all_values
end 
def get_all_values_nested(nested_hash={}) 
  nested_hash.each_pair do |k,v|
    @path << k
    case v
      when String, Fixnum then 
        @all_values.merge!({"#{@path.join(".")}" => "#{v}"}) 
        @path.pop
      when Hash then get_all_values_nested(v)
      else raise ArgumentError, "Unhandled type #{v.class}"
    end
  end
  @path.pop

  return @all_values
end 

def set_value_from_path(nested_hash,path_to_value,newValue)
  path_array = path_to_value.split "."
  last_key = path_array.pop
  hash = create_hash_with_path(path_array,{last_key=>newValue})
  self.merge!(nested_hash,hash)
end 


def create_hash_with_path(path_array,hash)
  newHash = Hash.new
  tempHash = Hash.new
  flag = 1
  path_array.reverse.each do |value|
    if flag == 1
      tempHash = hash
      flag = 0
    else
      tempHash = newHash 
    end 
    newHash = {value => tempHash}
  end 

  return newHash
end

  def mergehash!(wordlist) 
    wordlist.each do |word|
      puts word
      hsh = word.chars.to_a.reverse.inject(){|mem,var| {var => mem}}
      if hsh.class == Hash
        puts hsh.inspect
        merge!(hsh) 
      end
    end
    self
  end 

  def merge!(merge1,merge2)
    case merge1
    when String,Fixnum then merge2
    else merge1.merge!(merge2) {|key,old_value,new_value| self.merge!(old_value,new_value)} if merge1 && merge2
    end 
  end 
end 

class String
  def hashize 
    return self.chars.to_a.reverse.inject(){|mem,var| {var => mem}}
  end 
end 

