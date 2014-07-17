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
  end

  def jump(new_pos)
  end

  def slide_moves
    MOVE_DELTAS[color].each_with_object([]) do |(d_row, d_col), slide_moves|
      move = [self.position[0] + d_row, self.position[1] + d_col]
      if @board.in_bounds?(move) && !@board.pos_occupied?(move)
        slide_moves << move
      end
    end
  end

  def jump_moves
    MOVE_DELTAS[color].each_with_object([]) do |(d_row, d_col), jump_moves|
      slide_move = [self.position[0] + d_row, self.position[1] + d_col]
      jump_move = [self.position[0] + d_row * 2, self.position[1] + d_col * 2]

      if @board.in_bounds?(jump_move) && !@board.pos_occupied?(jump_move) &&
         (@board.pos_occupied?(slide_move) &&
         @board[slide_move].color != self.color)

         jump_moves << jump_move
       end
    end
  end

end


