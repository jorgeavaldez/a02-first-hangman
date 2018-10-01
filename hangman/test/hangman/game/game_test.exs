defmodule GameTest do
  use ExUnit.Case
  doctest Hangman.Game

  test "initializes correctly" do
    game = Hangman.Game.new_game()

    assert game.status == :initializing
    assert game.word
    assert game.last_guess == nil
    assert game.used == []
    assert game.bad_guesses == 0
  end

  test "generates a correct initial tally" do
    game = Hangman.Game.new_game()

    correct_letters = Enum.map(String.codepoints(game.word), fn _ -> "_" end)

    tally = Hangman.Game.tally(game)
    assert tally.letters
    assert tally.letters == correct_letters

    assert tally == %Hangman.Tally{ letters: correct_letters }
  end

  test "updates the game state correctly for a correct move" do
    game = Hangman.Game.new_game()

    # grab an obviously correct guess
    good_guess = String.at(game.word, 0)

    { game, tally } = Hangman.Game.make_move(game, good_guess)

    # check game state
    assert game.status == :good_guess
    assert game.bad_guesses == 0
    assert game.last_guess == good_guess

    assert tally.turns_left == 7

    # check that the used field contains our guess
    assert Enum.count(game.used) == 1
    [ used_candidate_guess | [] ] = game.used
    assert used_candidate_guess == good_guess

    # ensure that we have less underscores than the length of the word
    word_len = Enum.count(String.codepoints(game.word))
    num_underscores = Enum.count(game.letters, fn letter -> letter == "_" end)

    assert num_underscores < word_len
  end

  test "updates the game state correctly for an incorrect move" do
    game = Hangman.Game.new_game()

    # create an obviously incorrect guess
    bad_guess = -1

    { game, tally } = Hangman.Game.make_move(game, bad_guess)

    # check game state
    assert game.status == :bad_guess
    assert game.bad_guesses == 1
    assert game.last_guess == bad_guess

    assert tally.turns_left == 6

    # check that the used field contains our guess
    assert Enum.count(game.used) == 1
    [ used_candidate_guess | [] ] = game.used
    assert used_candidate_guess == bad_guess

    # ensure that we have the same amount of underscores as the length of the word
    word_len = Enum.count(String.codepoints(game.word))
    num_underscores = Enum.count(game.letters, fn letter -> letter == "_" end)

    assert num_underscores == word_len
  end

  test "updates the game state correctly for a win" do
    game = Hangman.Game.new_game()
    good_guesses = String.codepoints(game.word)

    # run through the game and grab the last game state
    game = Enum.reduce(good_guesses, game, fn guess, state ->
      { new_state, _tally } = Hangman.Game.make_move(state, guess)
      new_state
    end)

    # check game state
    assert game.status == :won
    assert game.bad_guesses == 0
  end
end
