defmodule TallyTest do
  use ExUnit.Case
  doctest Hangman.Tally

  test "initializes correctly" do
    tally = %Hangman.Tally{}

    assert tally.game_state == :initializing
    assert tally.turns_left == 7
    assert tally.letters == []
    assert tally.used == []
    assert tally.last_guess == nil
  end
end
