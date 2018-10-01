defmodule Hangman.Game.State do
  defstruct(
    status: :initializing,
    word: "",
    last_guess: nil,
    letters: [],
    used: [],
    bad_guesses: 0
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

  defp find_in_letters(target, letters) do
    Enum.find_index(letters, fn letter -> letter == target end)
  end

  # guess not found, last_index was nil
  defp locations_of_helper(_guess, _word, nil, _offset), do: []

  # find rest of the occurrences
  defp locations_of_helper(guess, word_letters, index, offset) do
    rest_of_word = Enum.slice(word_letters, index + 1..-1)

    [
      index + offset |
      locations_of_helper(
        guess,
        rest_of_word,
        find_in_letters(guess, rest_of_word),
        index + offset + 1
      )
    ]
  end

  # returns locations of guess within game.word
  def locations_of(guess, game) do
    letters = String.codepoints(game.word)
    locations_of_helper(guess, letters, find_in_letters(guess, letters), 0)
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
    %Hangman.Game.State{
      game |
      status: :bad_guess,
      bad_guesses: game.bad_guesses + 1
    }
    |> update_used(guess)
  end

  def make_move(game, guess) do
    %Hangman.Game.State{
      game |
      last_guess: guess,
    }
  end

  defp did_win(game, false), do: game
  defp did_win(game, true) do
    %Hangman.Game.State{
      game |
      status: :won
    }
  end

  defp did_lose(game, false), do: game
  defp did_lose(game, true) do
    %Hangman.Game.State{
      game |
      status: :lost
    }
  end

  defp won?(game) do
    num_underscores = Enum.count(game.letters, fn letter -> letter == "_" end)
    word = List.to_string(game.letters)

    win_condition = word == game.word && num_underscores == 0

    {
      win_condition,
      did_win(game, win_condition)
    }
  end

  defp lost?(game) do
    word = List.to_string(game.letters)
    turns_left = Hangman.Game.tally(game).turns_left

    lose_condition = word != game.word && turns_left == 0

    {
      lose_condition,
      did_lose(game, lose_condition)
    }
  end

  def check_win_loss(game) do
    check_win_loss_helper(game, won?(game), lost?(game))
  end

  # no win, no loss
  defp check_win_loss_helper(
    game,
    { false, _won_game },
    { false, _lost_game}), do: game

  # won
  defp check_win_loss_helper(
    _game,
    { true, won_game },
    { false, _lost_game}), do: won_game

  # lost
  defp check_win_loss_helper(
    _game,
    { false, _won_game },
    { true, lost_game}), do: lost_game
end
