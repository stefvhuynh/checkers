require_relative "illegal_move_error"

class Piece

  MOVE_DELTAS = {
    :red   => [[-1, 1], [-1, -1]],
    :black => [[1, 1], [1, -1]],
    :king  => [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  }

  attr_accessor :position, :kinged
  attr_reader :color

  def initialize(board, position, color)
    @board = board
    @position, @color = position, color
    @kinged = false
  end

  def slide(new_pos)
    moves.include?(new_pos) ? make_move : raise IllegalMoveError
  end

  def jump(new_pos)
    if moves.include?(new_pos)
      # Find the jumped piece by calculating the midpoint between the piece's
      # current position and landing position.
      jumped_piece_pos = [(self.position[0] + new_pos[0]) / 2,
                          (self.position[1] + new_pos[1]) / 2]
      @board[jumped_piece_pos] = nil
      make_move
    else
      raise IllegalMoveError
    end
  end

  def moves
    MOVE_DELTAS[color].each_with_object([]) do |(d_row, d_col), moves|
      slide_move = [self.position[0] + d_row, self.position[1] + d_col]
      jump_move = [self.position[0] + d_row * 2, self.position[1] + d_col * 2]

      # If slide_move is valid then jump_move is automatically invalid because
      # there is no piece to jump over.
      if @board.valid_pos?(slide_move)
        moves << slide_move
      elsif @board.valid_pos?(jump_move) &&
            @board[slide_move].color != self.color

        moves << jump_move
      end
    end
  end

  private

  def make_move
    # Set the board's new_pos to this piece, empty the space where this piece
    # was, and reassign this piece's position attribute.
    @board[new_pos] = self
    @board[self.position] = nil
    self.position = new_pos
  end

end


