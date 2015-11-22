class Node
  attr_accessor :word, :children, :level

  def initialize(word, level = 0)
    @word = word
    @children = []
    @level = level
  end

  def add_child(node)
    node.level = @level + 1
    @children << node
  end


  def to_s
    str = "#{' ' * @level}#{word}\n|_"
    children.each do |c|
      str = str + c.to_s
    end
    str
  end
end

# Get variations, and use the dictionary of valid words to exclude
# those that are not valid words or that have already been encountered
# at a higher level
def get_variations(word, valid_words, already_encountered)

  variations = []
  counter = 0
  while counter < word.length
    letter = word.split("")[counter]
    next_char = letter
    loop do
      if next_char == 'z'
        next_char = 'a'
      else
        next_char = next_char.next
      end
      break if next_char == letter
      word_new = word.clone
      word_new[counter] = next_char
      variations << word_new if valid_words.include?(word_new) && !already_encountered.include?(word_new)
    end
    counter = counter + 1
  end
  variations
end

def build_variations_tree(word, v_words, e_words = [])
  e_words << word if e_words.length == 0
  n = Node.new(word)
  words = get_variations(word, v_words, e_words)
  words.each do |w|
    e_words << w
    nn = Node.new(w)
    n.add_child(nn)
  end
  add_children(n, v_words, e_words.clone)

  n
end

def add_children(node, v_words, e_words)
  words = get_variations(node.word, v_words, e_words)
  words.each do |w|
    e_words << w
    nn = Node.new(w)
    node.add_child(nn)
  end
  node.children.each do |c|
    add_children(c, v_words, e_words.clone)
  end
end


#Dictionary of valid words
valid_words = ['fun','fan', 'fin', 'pin', 'gun', 'pun']

word_path = build_variations_tree('fan', valid_words)
puts word_path

