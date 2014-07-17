require_relative "piece"

class Board

  def self.generate_grid
    Array.new(8) { Array.new(8) }
  end

  attr_accessor :taken_pieces

  def initialize(blank = false)
    @grid = self.class.generate_grid
    @taken_pieces = []
    populate if !blank
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, obj)
    row, col = pos
    @grid[row][col] = obj
  end

  def populate
    self.each_index do |row, col|
      # Only populate every other position in the top three rows with black
      if row < 3 && (row + col).odd?
        self[[row, col]] = Piece.new(self, [row, col], :black)
      # Only populate every other position in the bottom three rows with red
      elsif row > 4 && (row + col).odd?
        self[[row, col]] = Piece.new(self, [row, col], :red)
      end
    end
  end

  def valid_pos?(pos)
    (in_bounds?(pos) && !pos_occupied?(pos)) ? true : false
  end

  def dup
    Board.new(blank = true).tap do |dup_board|
      self.each_with_index do |obj, row, col|
        dup_board[[row, col]] =
          Piece.new(dup_board, obj.position, obj.color) unless obj.nil?
      end
    end
  end

  def each(&blk)
    @grid.each do |row|
      row.each { |obj| blk.call(obj) }
    end
  end

  def each_row(&blk)
    @grid.each { |row| blk.call(row) }
  end

  def each_index(&blk)
    @grid.each_with_index do |row, row_i|
      row.each_index { |col_i| blk.call(row_i, col_i) }
    end
  end

  def each_with_index(&blk)
    @grid.each_with_index do |row, row_i|
      row.each_with_index { |obj, col_i| blk.call(obj, row_i, col_i) }
    end
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
d = b.dup
b[[0, 1]].position = [3, 2]
b.each_row { |row| p row }
d.each_row { |row| p row }



