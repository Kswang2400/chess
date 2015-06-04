
require_relative 'piece.rb'

class Bishop < SlidingPiece
  def display
    "♝"
  end

  def piece_moves
    bishop_moves
  end
end