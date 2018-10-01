defmodule Hangman.Game.State do
  defstruct(
    word: "",
    status: :initializing,
    turn: 0,
    used: [],
    last_guess: nil,
    letters: []
  )

  defp word_to_underscores(word) do
    Enum.map(String.codepoints(word), fn _ -> "_" end)
  end

  def new_game do
    word = Dictionary.random_word()

    %Hangman.Game.State{
      word: word,
      letters: word_to_underscores(word)
    }
  end

  # guess not found
  defp locations_of_helper(_guess, _word, nil) do
    []
  end

  # find rest of the occurrences
  defp locations_of_helper(guess, word, index) do
    [ index | locations_of(guess, String.split(word, index))]
  end

  def locations_of(guess, game) do
    index = game.word
    |> String.codepoints
    |> Enum.find_index(fn letter -> letter == guess end)

    locations_of_helper(guess, game.word, index)
  end

  def is_used(guess, game) do
    Enum.find_index(game.used, fn letter -> letter == guess end)
  end

  def update_letters(game, _guess, []), do: game
  def update_letters(game, guess, [ guess_index | rest_indexes ]) do
    %Hangman.Game.State{
      game |
      letters: List.update_at(game.letters, guess_index, fn _ -> guess end)
    }
    |> update_letters(guess, rest_indexes)
  end

  def update_used(game, guess) do
    %Hangman.Game.State{
      game |
      used: Enum.sort([ guess | game.used ])
    }
  end

  def good_guess(game, guess, occurrences) do
    %Hangman.Game.State{ game | status: :good_guess }
    |> update_used(guess)
    |> update_letters(guess, occurrences)
  end

  def bad_guess(game, guess) do
    %Hangman.Game.State{ game | status: :bad_guess }
    |> update_used(guess)
  end

  def make_move(game, guess) do
    %Hangman.Game.State{
      game |
      last_guess: guess,
      turn: game.turn + 1
    }
  end
end
