require_relative "board"
require_relative "user_error"

class Checkers

  def initialize
    @board = Board.new
  end

  def play

    until over?
      begin
        @board.display
        start_pos, moves = get_user_input
        @board[start_pos].perform_moves(moves)
      rescue IllegalMoveError
        puts "That's not a valid move!"
        retry
      end
    end

  end

  def over?
  end

  def get_user_input
    begin
      print "Enter the position of the piece you want to move (ex: 1,2) "
      start_pos = gets.chomp.split(/,/).map(&:to_i)
      raise UserError if @board[start_pos].nil?
    rescue UserError
      puts "No piece there!"
      retry
    end

    print "Enter a move or a sequence of moves (ex: 3,4 5,6 7,4) "
    moves = gets.chomp.split(/ /)
    moves.map! { |move| move.split(/,/).map(&:to_i) }

    [start_pos] + [moves]
  end

end

Checkers.new.play


