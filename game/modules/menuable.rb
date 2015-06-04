
require_relative 'input'

module Menuable
  def main_menu
    p1human = true
    p2human = true
    menu_done = false
    selected = [2, 0]

    menu = [["  Player  ".cyan, " Computer "],
            ["  Player  ".cyan, " Computer "],
              ["    OK    ", "   Exit   "]]
    
    until menu_done
      render_main_menu(menu, selected)

      menu.each_with_index do |row, r|
        row.each_with_index { |item, i| menu[r][i] = item.on_black }
      end

      input = ChessInput.read_char

      case input
      when "\e[A"
        selected = [[selected[0] - 1, 0].max, selected[1]]
      when "\e[D"
        selected = [selected[0], [selected[1] - 1, 0].max]
      when "\e[B"
        selected = [[selected[0] + 1, 2].min, selected[1]]
      when "\e[C"
        selected = [selected[0], [selected[1] + 1, 1].min]
      when "\e"
        exit
      when " "
        if selected == [0, 1]
          menu[0][1] = menu[0][1].cyan
          menu[0][0] = menu[0][0].white
          p1human = false
        elsif selected == [1, 1]
          menu[1][1] = menu[1][1].cyan
          menu[1][0] = menu[1][0].white
          p2human = false
        elsif selected == [0, 0]
          menu[0][0] = menu[0][0].cyan
          menu[0][1] = menu[0][1].white
          p1human = true
        elsif selected == [1, 0]
          menu[1][0] = menu[1][0].cyan
          menu[1][1] = menu[1][1].white
          p2human = true
        elsif selected == [2, 0]
          menu_done = true
          continue = true
        elsif selected == [2, 1]
          menu_done = true
          continue = false
        end
      end
    end
    [p1human, p2human, continue]
  end

  def render_main_menu(menu, selected)
    menu[selected[0]][selected[1]] = menu[selected[0]][selected[1]].on_yellow
    system("clear")
    puts "\n\n\n".on_black
    print   "   Welcome to ASCII Chess - Fireworks Edition".cyan
    puts File.read('./game/ascii_art/logo.txt')
    puts "".on_black
    print "            #{"  White: ".red.on_white}  #{menu[0][0]}   #{menu[0][1]}\n"
    print "            #{"  Black: ".black.on_white}  #{menu[1][0]}   #{menu[1][1]}\n\n"
    print "                       #{menu[2][0]}   #{menu[2][1]}\n\n"
  end
end