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

end
