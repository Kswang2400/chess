
require_relative 'piece.rb'

class Rook < SlidingPiece
  def display
    "♜"
  end

  def piece_moves
    rook_moves
  end
end
