require_relative "illegal_move_error"
require "colorize"

class Piece

  MOVE_DELTAS = {
    :red   => [[-1, 1], [-1, -1]],
    :black => [[1, 1], [1, -1]],
    :king  => [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  }

  SYMBOLS = {
    :red => " ⚈ ".colorize(:red),
    :black => " ⚈ ".colorize(:black),
    :king => " ❂ "
  }

  attr_accessor :position, :king
  attr_reader :color

  def initialize(board, position, color)
    @board = board
    @position, @color = position, color
    @king = false
  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise IllegalMoveError
    end
  end

  def valid_move_seq?(move_sequence)
    begin
      dup_board = @board.dup
      dup_board[self.position].perform_moves!(move_sequence)
    rescue IllegalMoveError
      false
    else
      true
    end
  end

  def perform_moves!(move_sequence)
    # Try to perform a Piece#slide move. If it fails, try a Piece@jump move
    # check if there are available jumps at the ending position.
    begin
      slide(move_sequence.first)
    rescue IllegalMoveError
      move_sequence.each { |move| jump(move) }
      raise IllegalMoveError unless jump_moves.empty?
    end
  end

  def dup(board)
    dup_piece = Piece.new(board, self.position, self.color)
    dup_piece.king = self.king
    dup_piece
  end

  def render
    self.king ? SYMBOLS[:king].colorize(@color) : SYMBOLS[@color]
  end

  def slide(new_pos)
    # If a Piece#slide move is attempted, check the board for available
    # jumps first.
    if @board.jumps_available?(self.color)
      raise IllegalMoveError
    elsif slide_moves.include?(new_pos)
      make_move(new_pos)
    else
      raise IllegalMoveError
    end
  end

  def jump(new_pos)
    if jump_moves.include?(new_pos)
      # Find the jumped piece by calculating the midpoint between the piece's
      # current position and landing position.
      jumped_piece_pos = [(self.position[0] + new_pos[0]) / 2,
                          (self.position[1] + new_pos[1]) / 2]
      @board.taken_pieces << @board[jumped_piece_pos]
      @board[jumped_piece_pos] = nil

      make_move(new_pos)
    else
      raise IllegalMoveError
    end
  end

  def slide_moves
    hash_key = self.king ? :king : @color

    MOVE_DELTAS[hash_key].each_with_object([]) do |(d_row, d_col), slide_moves|
      slide_move = [self.position[0] + d_row, self.position[1] + d_col]
      slide_moves << slide_move if @board.valid_pos?(slide_move)
    end
  end

  def jump_moves
    hash_key = self.king ? :king : @color

    MOVE_DELTAS[hash_key].each_with_object([]) do |(d_row, d_col), jump_moves|
      jumped_pos = [self.position[0] + d_row, self.position[1] + d_col]
      jump_move = [self.position[0] + d_row * 2, self.position[1] + d_col * 2]

      if @board.valid_pos?(jump_move) && @board.pos_occupied?(jumped_pos) &&
         @board[jumped_pos].color != self.color

        jump_moves << jump_move
      end
    end
  end

  def make_move(new_pos)
    # Set the board's new_pos to this piece, empty the space where this piece
    # was, and reassign this piece's position attribute.
    @board[new_pos] = self
    @board[self.position] = nil
    self.position = new_pos

    # Promote to king if this piece is in the right position.
    self.king = true if promote?
  end

  def promote?
    unless self.king
      return true if self.position[0] == 0 || self.position[0] == 7
    end

    false
  end

end


