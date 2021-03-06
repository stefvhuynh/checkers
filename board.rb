require_relative "piece"
require "colorize"

class Board

  def self.generate_grid
    Array.new(8) { Array.new(8) }
  end

  attr_reader :taken_pieces

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
      # Only populate every other position in the top three rows with black.
      if row < 3 && (row + col).odd?
        self[[row, col]] = Piece.new(self, [row, col], :black)
      # Only populate every other position in the bottom three rows with red.
      elsif row > 4 && (row + col).odd?
        self[[row, col]] = Piece.new(self, [row, col], :red)
      end
    end
  end

  def game_over?
    red_count, black_count = 0, 0

    @taken_pieces.each do |piece|
      red_count += 1 if piece.color == :red
      black_count += 1 if piece.color == :black
    end

    (red_count == 12 || black_count == 12) ? true : false
  end

  def jumps_available?(color)
    self.each do |obj|
      if !obj.nil? && obj.color == color && !obj.jump_moves.empty?
        return true
      end
    end

    false
  end

  def dup
    Board.new(true).tap do |dup_board|
      self.each_with_index do |obj, row, col|
        dup_board[[row, col]] = obj.dup(dup_board) unless obj.nil?
      end
    end
  end

  def each_index(&blk)
    @grid.each_with_index do |row, row_i|
      row.each_index { |col_i| blk.call(row_i, col_i) }
    end
  end

  def each(&blk)
    @grid.each do |row|
      row.each { |obj| blk.call(obj) }
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

  def valid_pos?(pos)
    (in_bounds?(pos) && !pos_occupied?(pos)) ? true : false
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def display
    puts render
  end

  def render
    rendered = "   A  B  C  D  E  F  G  H\n"

    self.each_with_index do |obj, row, col|
      rendered += "#{8 - row} " if col == 0

      # Colorize the backgrounds for odd spaces.
      if (row + col).odd?
        if obj.nil?
          rendered += "   ".colorize(:background => :white)
        else
          rendered += obj.render.colorize(:background => :white)
        end
      else
        rendered += obj.nil? ? "   " : obj.render
      end

      rendered += "\n" if col == 7
    end

    rendered
  end

end


