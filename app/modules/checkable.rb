
module Checkable
  def checkmated?(color)
    no_moves_left?(color) && in_check?(color)
  end

  def find_king_pos(color)
    @squares.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return [i, j] if piece && piece.is_a?(King) && piece.color == color
      end
    end
  end

  def in_check?(color)
    king_pos = find_king_pos(color)
    opponent_pieces = all_pieces(opp_color(color))
    opponent_pieces
      .map { |piece| piece.spaces_threatened }
      .inject(&:+)
      .include?(king_pos)
  end

  def no_moves_left?(color)
    all_pieces(color).map { |piece| piece.valid_moves }
      .inject(&:+)
      .empty?
  end
end