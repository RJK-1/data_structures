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

  def update_board(pos)
    @board[pos[0]][pos[1]] = 'X'
  end

  def all_equal?
    @board.uniq.size <= 1
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
  attr_accessor :position, :move_to, :root

  def initialize(board)
    @board = board
    @position = nil
    @move_to = nil
    @root = nil
  end

  def update_position
    @board.update_board(@position)
  end

  def knight_moves(from, to)
    @position = from
    @move_to = to
    @board.update_board(@position)
    @root = calculate_moves
    find_node
  end

  def calculate_moves(current_node = nil)
    possible_moves = []
    action = [[2, 1], [1, 2]]
    current_node.nil? ? node = Node.new(@position) : node = current_node
    @board.update_board(node.data)

    possible_moves << [node.data[0] + action[0][0], node.data[1] + action[0][1]]
    possible_moves << [node.data[0] + action[1][0], node.data[1] + action[1][1]]
    possible_moves << [node.data[0] - action[0][0], node.data[1] - action[0][1]]
    possible_moves << [node.data[0] - action[1][0], node.data[1] - action[1][1]]
    possible_moves << [node.data[0] - action[0][0], node.data[1] + action[0][1]]
    possible_moves << [node.data[0] - action[1][0], node.data[1] + action[1][1]]
    possible_moves << [node.data[0] + action[0][0], node.data[1] - action[0][1]]
    possible_moves << [node.data[0] + action[1][0], node.data[1] - action[1][1]]

    possible_moves.select! do |n|
      n[0] >= 0 && n[1] >= 0 &&
        n[0] <= 7 && n[1] <= 7 && @board.board[n[0]][n[1]] != 'X'
    end
    possible_moves.delete(node.data)
    possible_moves.each { |n| node.moves << Node.new(n) }
    possible_moves.include?(@move_to) ? return : node.moves.each { |n| calculate_moves(n) }
    node
  end

  def find_node(node = @root)
    puts @board.board[2][0]
    #puts node.data
    queue = []
    queue << node
    queue << node.moves
    puts queue
    queue.each {|node| p node }
  end
end

board = Board.new
knight = Knight.new(board)

knight.knight_moves([0, 0], [2, 4])
