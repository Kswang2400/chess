
require "io/console"

class Player
  attr_reader :board

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def get_move
    raise ChessError.new("not yet implemented")
  end
end

class HumanPlayer < Player
  def initialize(color, board)
    puts "You are playing as #{color == :B ? "black" : "white"}."
    puts "Enter your name: ".green
    super(gets.chomp, color, board)
  end

  def get_move
    begin
      quit = false
      until quit
        board.display_board
        input = read_char
        sel_sq = board.selected_sq
        case input
        when "\e[A"
          board.selected_sq = [[sel_sq[0] - 1, 0].max, sel_sq[1]]
        when "\e[D"
          board.selected_sq = [sel_sq[0], [sel_sq[1] - 1, 0].max]
        when "\e[B"
          board.selected_sq = [[sel_sq[0] + 1, 7].min, sel_sq[1]]
        when "\e[C"
          board.selected_sq = [sel_sq[0], [sel_sq[1] + 1, 7].min]
        when "\r"
          if !board.selected_piece
            board.selected_piece = board.square(sel_sq)
          elsif sel_sq == board.selected_piece.pos
            board.selected_piece = nil
          else
            board.selected_piece.make_move(sel_sq)
          end
        when "\e"
          quit = true
        end
        board.display_board
      end
    rescue ChessError => e
      puts "here now"
    end
  end

  private
  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end
end
