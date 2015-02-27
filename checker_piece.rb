
class Piece

  attr_accessor :pos, :color, :board, :king_flag

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
    @king_flag = false
  end

  def perform_slide(end_pos)
    starting_pos = self.pos
    @board[end_pos] = self
    @board[starting_pos] = nil
    # self.pos = end_pos
    check_promotion(end_pos)
  end

  def perform_jump(end_pos)

    # while sliding_moves_valid?(end_pos)
    starting_pos = self.pos
    remove_enemy_piece(starting_pos, end_pos)
    @board[end_pos] = self
    @board[starting_pos] = nil
    # self.pos = end_pos
    check_promotion(end_pos)
  end

  def move_dirs

    return [-1, 1].repeated_permutation(2).to_a if @king_flag == true #if king_flag == true

    if @color == :red
      return [[1, -1], [1 ,1]]
    else #if @color == :blue
      return [[-1, -1], [-1, 1]]
    end
  end

  def sliding_moves_valid?(end_pos)
    possible_moves = []
    x = @pos[0]
    y = @pos[1]
    move_dirs.each do |pair|
      move = [x + pair[0], y + pair[1]]
      possible_moves << move if @board[move].nil? && move.all? { |i| i.between?(0, 7) }
    end
    p "possible sliding moves #{possible_moves}"
    return true if possible_moves.include?(end_pos)
    false
  end

  def jumping_move_valid?(end_pos)
    return false unless enemy_in_front?
    possible_moves = []
    x = @pos[0]
    y = @pos[1]
    move_dirs.each do |pair|
      if enemy_pos.include?([x + pair[0], y +pair[1]])
        move = [x + 2 * pair[0], y + 2 * pair[1]]
        possible_moves << move if @board[move].nil? && move.all? { |i| i.between?(0, 7) }
      end
    end
    p "possible jumping moves #{possible_moves}"
    return false if possible_moves.empty?
    true
  end

  def enemy_in_front?
    !enemy_pos.empty?
  end

  def enemy_pos #positions we can travel to with enemies on them when deciding slide or jump
    x = @pos[0]
    y = @pos[1]
    pos_with_enemy = []
    move_dirs.each do |pair|
      enemy = [x + pair[0], y + pair[1]]
      pos_with_enemy << enemy if !@board[enemy].nil? && @board[enemy].color != @color
    end
    p "positions with enemies: #{pos_with_enemy}"
    pos_with_enemy
  end

  def check_promotion(end_pos)
    if promote?(end_pos)
      self.king_flag = true
      self.render_piece
    end
    self.pos = end_pos
  end

  def promote?(end_pos)
    if self.color == :red
      return true if end_pos[0] == 7
    else
      return true if end_pos[0] == 0
    end
    false
  end

  def remove_enemy_piece(starting_pos, end_pos)
    x = starting_pos[0]
    y = starting_pos[1]
    i = end_pos[0]
    j = end_pos[1]
    enemy_x = (x < i) ? (x..i).reject { |n| n == x || n == i } : (i..x).reject { |n| n == x || n == i }
    enemy_y = (y < j) ? (y..j).reject { |n| n == y || n == j } : (j..y).reject { |n| n == y || n == j }
    enemy_pos = enemy_x + enemy_y
    @board[enemy_pos] = nil
  end

  def render_piece
    if @king_flag == false
      if @color == :red
        "⚉".colorize(:color => :red)
      else
        "⚉".colorize(:color => :blue)
      end
    else
      if @color == :red
        "♚".colorize(:color => :red)
      else
        "♚".colorize(:color => :blue)
      end
    end
  end

end
