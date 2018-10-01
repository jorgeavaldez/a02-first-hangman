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
end
