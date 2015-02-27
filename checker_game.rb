
require_relative "checker_board.rb"
require_relative "checker_piece.rb"
require 'byebug'

class Game
  attr_reader :game_board

  def initialize
    @game_board = Board.new
    @current_player = :red
  end

  def play
    until game_over?
      p @game_board.render_board
      puts "current player is: #{@current_player}"
      start = get_position
      ending = select_end_pos
      # debugger
      move_piece(start, ending)
      switch_player

    end
  end

  def get_position
    puts "please pick a piece's position"
    start = gets.chomp.split(" ").map(&:to_i) #[x, y]
  end

  def select_end_pos
    puts "please pick your piece's destination"
    ending = gets.chomp.split(" ").map(&:to_i)
  end

  def switch_player
    @current_player = (@current_player == :red) ? :blue : :red
  end

  def move_piece(start, ending)
    @game_board.move(start, ending)
  end

  def game_over?
    @game_board.one_color_remaining?
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
  game.game_board.move([2, 0], [3, 1])
  game.game_board.move([3, 1], [4, 2])
  game.game_board.move([5, 5], [4, 4])
  game.game_board.move([6, 4], [5, 5])
  game.game_board.move([5, 5], [4, 6])
  game.game_board.move([7, 5], [6, 4])
  game.game_board.move([6, 4], [5, 5])
  game.game_board.move([4, 2], [6, 4])
  game.game_board.move([6, 4], [7, 5])
  game.game_board.move([7, 5], [6, 4])
end
