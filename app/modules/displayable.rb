
module Displayable
  def display_board(clear = false)
    system("clear") if clear
    highlight = render_header

    @squares.each_with_index do |row, i|
      print (" " + (8 - i).to_s + " ").yellow.on_magenta
      print " "
      row.each_with_index do |piece, j|
        to_print = "   " if piece.nil?
        to_print =  " " + piece.display + " " unless piece.nil?
        to_print = piece && piece.color == :B ? to_print.black : to_print.red

        if highlight && highlight.include?([i, j])
          to_print = (i + j) % 2 == 1 ? to_print.on_green : to_print.on_yellow
        else
          to_print = (i + j) % 2 == 1 ? to_print.on_blue : to_print.on_white
        end

        to_print = to_print.on_magenta if selected_sq == [i, j]
        print to_print
      end
      puts ""
    end
    render_footer

    nil
  end

  def render_header
    puts "\n\n\n"
    puts "It is turn #{@count / 2}"
    highlight = selected_piece.valid_moves if selected_piece
    puts "#{white_name}, it is your move!".green if player_turn == :W
    puts "#{black_name}, it is your move!".green if player_turn == :B
    print "#{player_turn == :W ? "White" : "Black"}'s turn. "
    puts in_check?(player_turn) ? "You're in check!" : ""
    highlight
  end

  def render_footer
    puts "   ".on_magenta
    print "    ".yellow.on_magenta
    puts " a  b  c  d  e  f  g  h ".yellow.on_magenta
    print_check_statments
  end

  def print_check_statments
    puts ""
    puts "White in check: #{in_check?(:W)}"
    puts "Black in check: #{in_check?(:B)}"
    puts ""
    puts "White checkmated?: #{checkmated?(:W)}"
    puts "Black checkmated?: #{checkmated?(:B)}"
    puts ""
  end
end