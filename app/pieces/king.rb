
require_relative 'piece.rb'

class King < SteppingPiece
  def self.deltas
    @delta= [
        [-1, 1],  [0, 1],  [1, 1],
        [-1, 0],           [1, 0],
        [-1, -1], [0, -1], [1, -1]
      ]
  end

  def valid_moves
    reg_moves = super

    if !has_moved
      opp_attacks = @board.all_pieces(@board.opp_color(color))
        .map    { |piece| piece.spaces_threatened }
        .inject(&:+)

      k_row = pos.first

      @board.all_pieces(color).select { |piece| piece.class == Rook }.each do |rook|
        case rook.pos
        when [k_row, 7]
          in_between = [[k_row, 6], [k_row, 5]]
        when [k_row, 0]
          in_between = [[k_row, 2], [k_row, 3], [k_row, 1]]
        else
          in_between = []
        end

        unless in_between.empty? || rook.has_moved ||
               in_between.any? { |p| board.square(p) } ||
               in_between.take(2).any? { |p| opp_attacks.include?(p) }
          reg_moves << in_between.first
        end

      end
    end

    reg_moves
  end

  def make_move!(end_pos)
    if end_pos[1] - pos[1] > 1
      rook = @board.square([pos[0], 7])
      rook.make_move!([pos[0], 5])
    elsif end_pos[1] - pos[1] < -1
      rook = @board.square([pos[0], 0])
      rook.make_move!([pos[0], 3])
    end

    super
  end

  def display
    "♚"
  end
end
