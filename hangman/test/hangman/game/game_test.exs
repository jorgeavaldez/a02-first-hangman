defmodule GameTest do
  use ExUnit.Case
  doctest Hangman.Game

  test "initializes correctly" do
    game = Hangman.Game.new_game()

    assert game.word
    assert game.status == :initializing
    assert game.turn == 0
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
    assert game.turn == 0
    assert game.last_guess == good_guess

    # check that the used field contains our guess
    assert Enum.count(game.used) == 1
    [ candidate_guess | [] ] = game.used
    assert candidate_guess == good_guess

    # ensure that we have less underscores than the length of the word
    word_len = Enum.count(String.codepoints(game.word))
    num_underscores = Enum.count(game.used, fn letter -> letter == "_" end)

    assert num_underscores < word_len
  end
end
