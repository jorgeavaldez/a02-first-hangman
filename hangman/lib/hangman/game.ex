defmodule Hangman.Game do
  defmodule State do
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

    def initialize do
      word = Dictionary.random_word()

      %State{
        word: word,
        letters: word_to_underscores(word)
      }
    end

    defp locations_of(guess, game) do
      index = game.word
      |> String.codepoints
      |> Enum.find_index(fn letter -> letter == guess end)

      locations_of_helper(guess, game.word, index)
    end

    defp locations_of_helper(guess, word, nil) do
      []
    end

    defp locations_of_helper(guess, word, index) do
      [ index | locations_of(guess, String.split(word, index))]
    end

    defp is_used(guess, game) do
      Enum.find_index(game.used, fn letter -> letter == guess end)
    end
  end

  def new_game do
    State.initialize
  end

  # Initial tally
  def tally(%State{ status: :initializing, turn: 0 } = game) do
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
    new_game = %State{
      game |
      last_guess: guess,
      turn: game.turn + 1
    }
    |> check_guess(
      guess,
      State.locations_of(guess, game),
      State.is_used(guess, game))

    { game, tally(game) }
  end

  # duplicate guess
  def check_guess(game, _guess, _indexes, _previous_guess_index) do
    %State{ game | status: :already_used }
  end

  # wrong guess
  def check_guess(game, guess, [], nil) do
    %State{
      game |
      status: :bad_guess,
      used: Enum.sort([ guess | game.used ])
    }
  end

  # I should probably call the following recursively to make sure i get the
  # right game updates

  # correct guess, last appearance
  def check_guess(game, guess, [guess_index | []], nil) do
    # update letters a last/only time, prepare final game state
    %State{
      game |
      status: :good_guess,
      used: Enum.sort([ guess | game.used ]),
      letters: List.update_at(game.letters, guess_index, fn _ -> guess end)
    }
  end

  # correct guess, appears multiple times
  def check_guess(game, guess, [guess_index | rest_indexes], nil) do
    # update letters recursively
    # base case updates remaining fields and returns
    %State{
      game |
      letters: List.update_at(game.letters, guess_index, fn _ -> guess end)
    }
    |> check_guess(
      guess,
      rest_indexes,
      nil
    )
  end

end
