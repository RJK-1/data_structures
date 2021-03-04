class LinkedList
  attr_accessor :end, :start
  def initialize
    @end = nil
    @start = nil
  end

  def append(value)
    if @start == nil
      @start = Node.new(value)
    elsif @end == nil
      @end = Node.new(value)
      @start.next_node = @end.object_id
    else
      temp = Node.new(value)
      @end.next_node = temp.object_id
      @end = temp
    end
  end

  def prepend(value)
    if @start == nil
      @start = Node.new(value)
    else
      id = @start.object_id
      @start = Node.new(value)
      @start.next_node = id
    end
  end

  def size
    size = 0
    next_node = nil
    size += 1 if @start != nil
    next_node = @start.next_node
    while next_node != nil
      size += 1
      next_node = ObjectSpace._id2ref(next_node).next_node
    end
    size
  end

  def head
    @start.value
  end

  def tail
    @end.value
  end
  
  def at(index)
    next_node = @start.object_id
    index.times { next_node = ObjectSpace._id2ref(next_node).next_node }
    puts "Node at ##{index} is #{ObjectSpace._id2ref(next_node).value}"    
  end

  def pop
    next_node = @start.object_id
    length = size - 2
    length.times { next_node = ObjectSpace._id2ref(next_node).next_node }
    ObjectSpace._id2ref(next_node).next_node = nil
    to_s
  end

  def contains?(value)
    list = []
    next_node = nil
    list << "#{@start.value}"
    next_node = ObjectSpace._id2ref(@start.object_id).next_node

    while !next_node.nil?
      list << "#{ObjectSpace._id2ref(next_node).value}"
      next_node = ObjectSpace._id2ref(next_node).next_node
    end
    list.include?("#{value}")
  end

  def find(value)
    list = []
    index = nil
    next_node = nil
    list << "#{@start.value}"
    next_node = ObjectSpace._id2ref(@start.object_id).next_node

    while !next_node.nil?
      list << "#{ObjectSpace._id2ref(next_node).value}"
      next_node = ObjectSpace._id2ref(next_node).next_node
    end
    list.each_with_index { |val, idx| index = idx if val == value }
    index
  end

  def to_s
    list = []
    next_node = nil
    list << "( #{@start.value} ) -> "
    next_node = ObjectSpace._id2ref(@start.object_id).next_node

    while !next_node.nil?
      list << "( #{ObjectSpace._id2ref(next_node).value} ) -> "
      next_node = ObjectSpace._id2ref(next_node).next_node
    end
    list << 'nil'
    list = list.join()
  end

  def insert_at(value, index) #index 3
    next_node = @start.object_id
    temp = Node.new(value)
    before = nil
    (index - 1).times { next_node = ObjectSpace._id2ref(next_node).next_node }
    before = ObjectSpace._id2ref(next_node)
    next_node = ObjectSpace._id2ref(next_node).next_node
    before.next_node = temp.object_id
    temp.next_node = next_node
    to_s
  end

  def remove_at(index)
    next_node = @start.object_id
    before = nil
    (index - 1).times { next_node = ObjectSpace._id2ref(next_node).next_node }
    before = ObjectSpace._id2ref(next_node)
    2.times { next_node = ObjectSpace._id2ref(next_node).next_node}
    before.next_node = ObjectSpace._id2ref(next_node).object_id
    to_s
  end
end

class Node
  attr_accessor :value, :next_node
  def initialize(value)
    @value = value
    @next_node = nil
  end
end

linked_list = LinkedList.new

linked_list.append(1)
linked_list.append(2)
linked_list.append(3)
linked_list.append(4)
linked_list.append('Last')
linked_list.prepend('First')
puts linked_list.to_s
puts linked_list.head
puts linked_list.tail
puts "Size: #{linked_list.size}"
linked_list.at(4)
puts linked_list.pop
puts linked_list.contains?(1)
puts linked_list.contains?(5)
p linked_list.find('4')
p linked_list.find('Bob')
puts linked_list.insert_at('Insert', 3)
puts linked_list.remove_at(3)