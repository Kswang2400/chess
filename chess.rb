
require './app/game'

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end

# Notes

# Need to refactor EVERYTHING (board, king_moves, piece)
# Add screenshots for README
# Save/Load from YAML

