require_relative "piece"

class Board

  def self.generate_grid
    Array.new(8) { Array.new(8) }
  end

  attr_accessor :taken_pieces

  def initialize
    @grid = self.class.generate_grid
    @taken_pieces = []
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, obj)
    row, col = pos
    @grid[row][col] = obj
  end

  def valid_pos?(pos)
    (in_bounds?(pos) && !pos_occupied?(pos)) ? true : false
  end

  def each_row(&blk)
    @grid.each { |row| blk.call(row) }
  end

  def pos_occupied?(pos)
    self[pos].nil? ? false : true
  end

  def in_bounds?(pos)
    row, col = pos
    (row.between?(0, 7) && col.between?(0, 7)) ? true : false
  end

end


b = Board.new
p1 = Piece.new(b, [2, 3], :black)
p2 = Piece.new(b, [1, 2], :red)
p3 = Piece.new(b, [3, 2], :red)
b[p1.position] = p1
b[p2.position] = p2
b[p3.position] = p3
# p1.jump([4, 1])
p1.perform_moves!([[4, 1]])
b.each_row { |row| p row }



