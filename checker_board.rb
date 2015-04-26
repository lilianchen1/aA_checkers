
require "colorize"
require "byebug"
# require_relative 'checker_piece.rb'

class Board

  attr_accessor :grid

  def initialize
    #grid is the array
    @grid = create_board # board is an object (self refers to board object, not the grid)
  end

  def [](pos)
    # pos = [x, y], pos[0] == x
    # @grid[pos[0]][pos[1]]
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def create_board
    grid = Array.new(8) { Array.new(8, nil) }
    fill_grid(grid)
    grid
  end

  def valid_move?(start, ending)
    piece = self[start]
    if (piece.sliding_moves_valid?(ending) == false) && (piece.jumping_move_valid?(ending) == false)
      return false
    end
    true
  end

  def move(starting_pos, ending_pos)
    piece = self[starting_pos]
    if piece.sliding_moves_valid?(ending_pos)
      piece.perform_slide(ending_pos)
    elsif piece.jumping_move_valid?(ending_pos)
      piece.perform_jump(ending_pos)
    end
  end

  def render_board
    puts "  0  1  2  3  4  5  6  7"
    @grid.each_with_index do |row, row_idx|
      row_string = "#{row_idx}"
      row.each_with_index do |col, col_idx| #col is the value, which has piece object
        if (row_idx.even? && col_idx.even?) || (row_idx.odd? && col_idx.odd?)
          if col.nil? # no piece on them
            row_string += "   ".colorize(:background => :yellow)
          else
            row_string += " #{col.render_piece} ".colorize(:background => :yellow)
          end
        else
          if col.nil?
            row_string += "   ".colorize(:background => :light_black)
          else
            row_string += " #{col.render_piece} ".colorize(:background => :light_black)
          end
        end
      end
      puts row_string
    end
    true
  end

  def one_color_remaining?
    return true if piece_color_hash.values.include?(0)
    false
  end

  private

  def pieces
    @grid.flatten.compact
  end

  def piece_color_hash
    h = Hash.new(0)
    pieces.each do |piece|
      h[piece.color] += 1
    end
    h
  end

  def fill_grid(grid)

    grid.each_with_index do |row, row_idx|
      next unless [0, 1, 2, 5, 6, 7].include?(row_idx)
      if [0, 1, 2].include?(row_idx)
        row.each_with_index do |col, col_idx|
          if row_idx.even? && col_idx.even?
            grid[row_idx][col_idx] = Piece.new([row_idx, col_idx], :red, self)
          elsif row_idx.odd? && col_idx.odd?
            grid[row_idx][col_idx] = Piece.new([row_idx, col_idx], :red, self)
          end
        end
      elsif [5, 6, 7].include?(row_idx)
        row.each_with_index do |col, col_idx|
          if row_idx.even? && col_idx.even?
            grid[row_idx][col_idx] = Piece.new([row_idx, col_idx], :blue, self)
          elsif row_idx.odd? && col_idx.odd?
            grid[row_idx][col_idx] = Piece.new([row_idx, col_idx], :blue, self)
          end
        end
      end
    end
  end

end
