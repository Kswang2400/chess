
require_relative 'piece.rb'

class Knight < SteppingPiece
  def self.deltas
    @delta= [
        [-2, 1],  [-1, 2],  [1, 2],  [2, 1],
        [-2, -1], [-1, -2], [1, -2], [2, -1]
      ]
  end

  def display
    "♞"
  end
end