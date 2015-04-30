
require_relative 'piece.rb'


class Pawn < Piece
  attr_accessor :just_moved_two

  def initialize(pos, board, color, has_moved = false)
    super
    just_moved_two = false
  end

  def display
    "♟"
  end
  #
  # def valid_moves
  #   reg_moves = super
  #
  #   if pos[0] == (color == :W ? 3 : 4)
  #     adjacent_pcs = [ @board.square([pos[0], pos[1] + 1]),
  #                      @board.square([pos[0], pos[1] - 1]) ]
  #     adjacent_pcs.each do |piece|
  #       if piece && piece.class == Pawn && piece.just_moved_two
  #         reg_moves << [pos[0] + color == :W  ? (-1) : (1), piece.pos[1]]
  #       end
  #     end
  #   end
  #
  #   reg_moves
  # end

  def piece_moves
    all_moves = []
    dy = color == :B ? 1 : -1

    front_one_pos = [pos[0] + dy, pos[1]]
    front_two_pos = [pos[0] + dy + dy, pos[1]]
    cap_positions = [ [pos[0] + dy, pos[1] + 1], [pos[0] + dy, pos[1] - 1] ]


    all_moves << front_one_pos unless @board.square(front_one_pos)
    all_moves << front_two_pos unless @board.square(front_one_pos) ||
                                      @board.square(front_two_pos) ||
                                      has_moved

    cap_positions.each do |cap_pos|
      all_moves << cap_pos if @board.square(cap_pos) &&
                              @board.square(cap_pos).color != color
    end

    all_moves
  end

  def make_move!(end_pos)
    if end_pos[0] == (color == :B ? 7 : 0)
      @board.set_square(end_pos, Queen.new(end_pos, @board, color, true))
      @board.set_square(pos, nil)
    else
      super
    end
    just_moved_two = true if (pos[1] - end_pos[1]).abs == 2
  end
end
