defmodule Hangman.Game do
  defdelegate new_game, to: Hangman.Game.State

  # Initial tally
  def tally(%Hangman.Game.State{ status: :initializing, turn: 0 } = game) do
    %Hangman.Tally{
      letters: game.letters,
    }
  end

  def tally(game) do
    %Hangman.Tally{
      letters: game.letters
    }
  end

  def make_move(game, guess) do
    new_game = game
    |> Hangman.Game.State.make_move(guess)
    |> check_guess(guess)

    { new_game, tally(new_game) }
    guess
  end

  def check_guess(game, guess) do
    check_guess_helper(
      game, guess,
      Hangman.Game.State.locations_of(guess, game),
      Hangman.Game.State.is_used(guess, game)
    )
  end

  # wrong guess
  defp check_guess_helper(game, guess, [], nil) do
    Hangman.Game.State.bad_guess(game, guess)
  end

  # correct guess, appears multiple times
  defp check_guess_helper(game, guess, occurrences, nil) do
    Hangman.Game.State.good_guess(game, guess, occurrences)
  end

  # duplicate guess
  defp check_guess_helper(game, _guess, _indexes, _previous_guess_index) do
    %Hangman.Game.State{ game | status: :already_used }
  end
end
