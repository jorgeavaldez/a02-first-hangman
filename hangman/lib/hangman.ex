defmodule Hangman do

  defdelegate new_game(), to: Hangman.Game
  defdelegate tally(game), to: Hangman.Game
  defdelegate make_move(game, guess), to: Hangman.Game

end
