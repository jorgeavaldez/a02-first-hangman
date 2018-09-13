defmodule Hangman.Tally do

  defstruct(
    game_state: :initializing,
    turns_left: 7,
    letters: [],
    used: [],
    last_guess: nil
  )

end
