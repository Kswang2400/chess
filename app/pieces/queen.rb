
require_relative 'piece.rb'

class Queen < SlidingPiece
  def display
    "♛"
  end

  def piece_moves
    rook_moves + bishop_moves
  end
end

