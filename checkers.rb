require_relative "board"
require_relative "user_error"
require "yaml"

class Checkers

  COLUMNS = {
    :A => 0,
    :B => 1,
    :C => 2,
    :D => 3,
    :E => 4,
    :F => 5,
    :G => 6,
    :H => 7
  }

  def initialize
    @board = Board.new
    @turn = :red
  end

  def play
    puts "Welcome to Checkers! To save your game, type 'save' at any time.\n"

    until @board.game_over?
      toggle_turn

      @board.display
      puts "#{@turn.upcase} to move."

      begin
        start_pos, moves = get_user_input

        if start_pos == "SAVE"
          save_game
          puts "Game successfully saved!"
          return
        end

        @board[start_pos].perform_moves(moves)
      rescue IllegalMoveError
        puts "That's not a valid move!"
        retry
      end
    end

    puts "#{@turn.upcase} wins!"
  end

  def get_user_input
    begin
      print "Enter the position of the piece you want to move (ex: C3) "
      input = gets.chomp.upcase

      return input if input == "SAVE"

      start_pos = convert_user_input(input)
      raise UserError if @board[start_pos].nil?
    rescue UserError
      puts "No piece there!"
      retry
    end

    print "Enter a move or a sequence of moves (ex: E5 C7) "
    moves = gets.chomp.upcase.split(/ /)
    moves.map! { |move| convert_user_input(move) }

    [start_pos] + [moves]
  end

  def toggle_turn
    @turn = (@turn == :black) ? :red : :black
  end

  # Convert letter-number notation (ex: B3) to coordinates (row, col).
  def convert_user_input(input)
    processed_input = input.split(//).reverse
    [8 - processed_input[0].to_i, COLUMNS[processed_input[1].to_sym]]
  end

  def save_game
    print "Please name your save file: "
    filename = gets.chomp.downcase
    File.write("#{filename}.yml", YAML.dump(self))
  end

end

if __FILE__ == $PROGRAM_NAME
  print "Would you like to load a save file or start a new game (load/new)? "
  input = gets.chomp.downcase
  if input == "new"
    Checkers.new.play
  elsif input == "load"
    print "What is the name of your save file? "
    filename = gets.chomp.downcase
    YAML.load_file("#{filename}.yml").play
  end
end


