
require_relative 'player'
require_relative 'board'
require_relative 'main_menu'

require 'colorize'

class Game
  include MainMenu
  attr_accessor :game_board
  attr_reader :player1, :player2

  def initialize
    @game_board = Board.new
  end

  def play
    setup

    until @game_board.game_over?
      @game_board.display_board(true)
      @game_board.player_turn == :W ?
        player1.get_move : player2.get_move
    end
  end

  def setup
    h_players = main_menu

    return unless h_players[2]

    @player1 = h_players[0] ? HumanPlayer.new(:W, @game_board) :
                              ComputerPlayer.new("Magnus 128K", :W, @game_board)
    @player2 = h_players[1] ? HumanPlayer.new(:B, @game_board) :
                              ComputerPlayer.new("Deep Red Ruby", :B, @game_board)
                              
    @game_board.white_name = player1.name
    @game_board.black_name = player2.name
  end
end
