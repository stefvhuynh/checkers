class IllegalMoveError < StandardError
  def initialize(msg = "IllegalMoveError: proposed move is not valid")
    super
  end
end


