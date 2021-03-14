# Class initializes 8x8 chess board.
class Board
  attr_accessor :board

  def initialize
    @board = create_board
  end

  def create_board
    @board = Array.new(8) { Array.new(8) }
    @board.map do |row|
      row.map { |element| element = 'O' }
    end
  end

  def update_board(old, new = nil)
    @board[old[0]][old[1]] = 'K' if !old.nil?
  end

  def all_equal? 
    @board.uniq == ['yes'] 
  end
end

# Class containing nodes with all possible moves from current position.
class Node
  attr_accessor :data, :moves

  def initialize(position)
    @data = position
    @moves = []
  end
end

# Class initalizing knight piece and methods controlling it's moves.
class Knight
  attr_accessor :position

  def initialize(board)
    @board = board
    @position = nil
    @move_to = nil
  end
  
  def update_position
    @board.update_board(@position)
  end

  def knight_moves(from, to)
    @position = from
    @move_to = to
    #@board.update_board(@position)
    p @board
    calculate_moves
  end

  def calculate_moves(current_node = nil, parent = nil)
    possible_moves = []
    action = [[2, 1], [1, 2]]

    current_node.nil? ? node = Node.new(@position) : node = current_node
    parent_node = node

    possible_moves << [node.data[0] + action[0][0], node.data[1] + action[0][1]]
    possible_moves << [node.data[0] + action[1][0], node.data[1] + action[1][1]]
    possible_moves << [node.data[0] - action[0][0], node.data[1] - action[0][1]]
    possible_moves << [node.data[0] - action[1][0], node.data[1] - action[1][1]]
    possible_moves << [node.data[0] - action[0][0], node.data[1] + action[0][1]]
    possible_moves << [node.data[0] - action[1][0], node.data[1] + action[1][1]]
    possible_moves << [node.data[0] + action[0][0], node.data[1] - action[0][1]]
    possible_moves << [node.data[0] + action[1][0], node.data[1] - action[1][1]]

    possible_moves.select! { |n| n[0].positive? && n[1].positive? }

    if parent_node != node
      parent_node.moves.each {|n| possible_moves.delete(n.data) }
    end

    possible_moves.select! { |n| n[0] <= 7 && n[1] <= 7 }
    possible_moves.delete(@position)

    #p node
    #possible_moves.each { |n| node.moves << Node.new(n) } 
    #node.moves.each {|n| calculate_moves(n, parent_node) }
  end
  
end

board = Board.new
knight = Knight.new(board)


knight.knight_moves([0, 0], [2, 4])
