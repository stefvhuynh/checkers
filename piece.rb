require_relative "illegal_move_error"

class Piece

  MOVE_DELTAS = {
    :red   => [[-1, 1], [-1, -1]],
    :black => [[1, 1], [1, -1]],
    :king  => [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  }

  attr_accessor :position, :king
  attr_reader :color

  def initialize(board, position, color)
    @board = board
    @position, @color = position, color
    @king = false
  end

  def valid_move_seq?(move_sequence)

  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      begin
        slide(move_sequence.first)
      rescue IllegalMoveError
        jump(move_sequence.first)
      end
    else
      begin
        move_sequence.each { |move| jump(move) }
      rescue IllegalMoveError
      end
    end
  end

  private

  def slide(new_pos)
    if slide_moves.include?(new_pos)
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
    MOVE_DELTAS[color].each_with_object([]) do |(d_row, d_col), slide_moves|
      slide_move = [self.position[0] + d_row, self.position[1] + d_col]
      slide_moves << slide_move if @board.valid_pos?(slide_move)
    end
  end

  def jump_moves
    MOVE_DELTAS[color].each_with_object([]) do |(d_row, d_col), jump_moves|
      jumped_pos = [self.position[0] + d_row, self.position[1] + d_col]
      jump_move = [self.position[0] + d_row * 2, self.position[1] + d_col * 2]

      # If slide_move is valid then jump_move is automatically invalid because
      # there is no piece to jump over.
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
    @king = true if promote?
  end

  def promote?
    unless self.king
      return true if self.position[0] == 0 || self.position[0] == 7
    end

    false
  end

  def inspect
    {
      position: self.position }.inspect
  end

end


