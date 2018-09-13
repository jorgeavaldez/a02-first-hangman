defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "contains new_game" do
    assert Hangman.new_game() == :empty
  end
end
