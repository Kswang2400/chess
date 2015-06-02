
class Piece
  attr_accessor :pos, :has_moved
  attr_reader :color, :board

  def initialize(pos, board, color, has_moved = false)
    @pos = pos
    @board = board
    @color = color
    @has_moved = has_moved
  end

  def deep_dup(new_board)
    self.class.new(pos.dup, new_board, color, has_moved)
  end

  def make_move(end_pos)
    if valid_moves.include?(end_pos)
      make_move!(end_pos)
      board.player_turn = board.opp_color(color)
      board.selected_piece = nil
      @board.count += 1
      return true
    end

    false
  end

  def make_move!(end_pos)
    board.update_square(pos, end_pos)
    self.pos = end_pos
    self.has_moved = true

    #remove en passant possibilities
    (board.all_pieces(:B) + board.all_pieces(:W))
      .select { |piece| piece.class == Pawn }
      .each   { |pawn|  pawn.just_moved_two = false }
  end

  def valid_moves
    spaces_threatened.reject do |move|
      duped_board = @board.deep_dup
      duped_piece = duped_board.square(pos)
      duped_piece.make_move!(move)
      duped_board.in_check?(color)
    end
  end

  def spaces_threatened
    piece_moves.select { |new_pos| (0..7).include?(new_pos[0]) &&
                                   (0..7).include?(new_pos[1]) }
  end

  def display
    raise ChessError.new("Unimplemented method")
  end

  def piece_moves
    raise ChessError.new("Unimplemented method")
  end
end

class SteppingPiece < Piece
  def piece_moves
    self.class.deltas.map { |move| [pos[0] + move[0], pos[1] + move[1]]}
      .reject {|move|   @board.square(move) &&
                        @board.square(move).color == color }
  end
end

class SlidingPiece < Piece

  def sliding_moves(deltas)
    all_moves = []

    deltas.each do |delta|
      (1..7).each do |increment|
        next_x = pos[0] + delta[0] * increment
        next_y = pos[1] + delta[1] * increment
        next_pos = [next_x, next_y]
        all_moves << next_pos unless  @board.square(next_pos) &&
                                      @board.square(next_pos).color == color
        break if @board.square(next_pos)
      end
    end

    all_moves
  end

  def rook_moves
    sliding_moves( [[-1, 0], [1, 0], [0, -1], [0, 1]] )
  end


  def bishop_moves
    sliding_moves( [[1, 1], [1, -1], [-1, 1], [-1,-1]] )
  end
end


class ChessError < RuntimeError
end
