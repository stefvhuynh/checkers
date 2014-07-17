class UserError < StandardError
  def initialize(msg = "UserError: invalid input")
    super
  end
end


