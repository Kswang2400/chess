
require 'require_all'
# require 'yaml'

require_all './app/pieces'
require_relative 'displayable'
require_relative 'checkable'

class Board
  include Displayable
  include Checkable
  attr_accessor :squares, :selected_piece, :selected_sq
  attr_accessor :white_name, :black_name
  attr_accessor :player_turn, :count

  def initialize(init = true)
    @squares = Array.new(8) { Array.new(8) }
    @selected_piece = nil
    @selected_sq = [3,3]
    # @squares = YAML::load(File.read("init.yml"))  #See history.log
    set_new_game_positions if init
    @player_turn = :W if init
    @count = 2
  end

  def all_pieces(color)
    all_pieces = []

    @squares.each do |row|
      row.each do |piece|
        all_pieces << piece if piece && piece.color == color
      end
    end

    all_pieces
  end

  def set_new_game_positions
    @squares[0][4] = King.new([0, 4], self, :B)
    @squares[7][4] = King.new([7, 4], self, :W)

    @squares[0][3] = Queen.new([0, 3], self, :B)
    @squares[7][3] = Queen.new([7, 3], self, :W)

    @squares[0][0] = Rook.new([0, 0], self, :B)
    @squares[0][7] = Rook.new([0, 7], self, :B)
    @squares[7][0] = Rook.new([7, 0], self, :W)
    @squares[7][7] = Rook.new([7, 7], self, :W)

    @squares[0][1] = Knight.new([0, 1], self, :B)
    @squares[0][6] = Knight.new([0, 6], self, :B)
    @squares[7][1] = Knight.new([7, 1], self, :W)
    @squares[7][6] = Knight.new([7, 6], self, :W)

    @squares[0][2] = Bishop.new([0, 2], self, :B)
    @squares[0][5] = Bishop.new([0, 5], self, :B)
    @squares[7][2] = Bishop.new([7, 2], self, :W)
    @squares[7][5] = Bishop.new([7, 5], self, :W)

    (0..7).each do |file|
      @squares[1][file] = Pawn.new([1, file], self, :B)
      @squares[6][file] = Pawn.new([6, file], self, :W)
    end

    # File.open("init.yml", 'w') do |file|
    #   file.puts(@squares.to_yaml)
    # end
  end

  def deep_dup
    dup_board = Board.new(false)
    pieces = squares.flatten.compact
    pieces.each do |piece|
      row, col = piece.pos[0], piece.pos[1]
      dup_board.squares[row][col] = piece.deep_dup(dup_board)
    end

    dup_board.player_turn = player_turn
    dup_board
  end

  def game_over?
    checkmated?(:W) || checkmated?(:B)
    #add conditions for draw (stalemate)
  end

  def update_square(old_pos, new_pos)
    piece = @squares[old_pos[0]][old_pos[1]]
    @squares[old_pos.first][old_pos.last] = nil
    @squares[new_pos.first][new_pos.last] = piece
    self.selected_piece = nil
  end

  def square(pos)
    return nil unless pos.all? { |coord| (0..7).include?(coord) }
    @squares[pos[0]][pos[1]]
  end

  def set_square(pos, piece)
    squares[pos[0]][pos[1]] = piece
  end

  def win
    start_time = Time.now
    until Time.now - start_time > 6
      puts File.read("./ascii_art/win_art_blank.txt").yellow
      sleep(0.2)
      system('cls')
      puts File.read("./ascii_art/win_art_right1.txt").blue
      sleep(0.2)
      system('cls')
      puts File.read("./ascii_art/win_art_blank.txt").yellow
      sleep(0.2)
      system('cls')
      puts File.read("./ascii_art/win_art_left.txt").red
      sleep(0.2)
      system('cls')
      puts File.read("./ascii_art/win_art_blank.txt").yellow
      sleep(0.2)
      system('cls')
      puts File.read("./ascii_art/win_art_right2.txt").green
      sleep(0.2)
      system('cls')
      puts File.read("./ascii_art/win_art_blank.txt").yellow
      sleep(0.2)
      system('cls')
      puts File.read("./ascii_art/win_art_left.txt").magenta
      sleep(0.2)
      system('cls')
      puts File.read("./ascii_art/win_art_blank.txt").yellow
    end
  end

  def opp_color(color)
    color == :B ? :W : :B
  end
end
