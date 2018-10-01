defmodule Hangman.Tally do
  defstruct(
    game_state: :initializing,
    turns_left: 7,
    letters: [],
    used: [],
    last_guess: nil
  )

  def from_game_state(state) do
    %Hangman.Tally{
      game_state: state.status,
      turns_left: 7 - state.turn,
      letters: state.letters,
      used: state.used,
      last_guess: state.last_guess
    }
  end
end
