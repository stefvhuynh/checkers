require_relative "piece"

class Board

  def self.generate_grid
    Array.new(8) { Array.new(8) }
  end

  def initialize
    @grid = self.class.generate_grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, obj)
    row, col = pos
    @grid[row][col] = obj
  end

  def pos_occupied?(pos)
    return self[pos].nil? ? false : true
  end

  def in_bounds?(pos)
    row, col = pos
    return (row.between?(0, 7) && col.between?(0, 7)) ? true : false
  end

end


b = Board.new
p1 = Piece.new(b, [0, 1], :black)
p2 = Piece.new(b, [1, 2], :red)
b[p1.position] = p1
b[p2.position] = p2
p p1.slide_moves



