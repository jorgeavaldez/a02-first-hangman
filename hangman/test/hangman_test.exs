defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "new_game returns a game" do
    assert Hangman.new_game()
  end
end
