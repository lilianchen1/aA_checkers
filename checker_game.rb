
require_relative "checker_board.rb"
require_relative "checker_piece.rb"
require_relative "errors.rb"
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
      ending = select_end_pos(start)
      # debugger
      move_piece(start, ending)
      switch_player

    end
  end

  def get_position
    begin
      puts "please pick a piece's position"
      start = gets.chomp.split(" ").map(&:to_i) #[x, y]
      raise ArgumentError.new if !start.all? { |i| i.between?(0, 7) } || start.length != 2
      raise NotValidMoveError.new if @game_board[start].nil? || @game_board[start].color != @current_player
    rescue NotValidMoveError
      puts "not a valid piece to choose"
      retry
    rescue ArgumentError
      puts "wtf? that's not even on the board"
      retry
    end
    start
  end

  def select_end_pos(start)
    begin
      puts "please pick your piece's destination"
      ending = gets.chomp.split(" ").map(&:to_i)
      raise ArgumentError.new if !ending.all? { |i| i.between?(0, 7) } || ending.length != 2
      raise NotValidMoveError.new unless @game_board.valid_move?(start, ending)
    rescue NotValidMoveError
      puts "not a valid destination to choose"
      retry
    rescue ArgumentError
      puts "wtf? that's not even on the board"
      retry
    end
    ending
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
  game.play
end
