class Trie

  # modified from wikipedia simple ruby trie struct
  # need a stop key to store the matching word
  #
  attr_accessor :root

  def initialize()
    @root = Hash.new()
  end

  def build(str) 
    node = @root
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
    node = @root
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
