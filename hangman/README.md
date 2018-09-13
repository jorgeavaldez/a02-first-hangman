# Hangman

Implements the `hangman` project as described
[here](https://github.com/cse5391-ff/a02-first-hangman).

## API

~~~ elixir
Hangman.new_game()                # returns a struct representing a new game

Hangman.tally(game)               # returns the tally for the given game

Hangman.make_move(game, guess)    # returns a tuple containing the updated game
                                  # state and a tally
~~~

The `tally` is a map containing the following fields:

~~~ elixir
game_state:    # :won | :lost | :already_used | :good_guess | :bad_guess | :initializing
turns_left:    # the number of turns left (game starts with 7)
letters:       # a list of single character strings. If a letter in a particular
               # position has been guessed, that letter will appear in `letters`.
               # Otherwise, it will be shown as an underscore
used:          # A sorted list of the letters already guessed
last_guess:    # the last letter guessed by the player
~~~

This tally is used by projects we'll be writing later. It allows them to display the
state of the game.

## Usage

Here's a sample iex session that shows the Hangman module being exercised.

~~~ elixir
iex> game = Hangman.new_game()
# ...

iex> Hangman.tally(game)
%{ game_state: :initializing, turns_left: 7, letters: ["_", "_", "_"], used: [] }

iex> { game, tally } = Hangman.make_move(game, "a")
# ...

iex> tally
%{ game_state: :good_guess, turns_left: 7, letters: ["_", "a", "_"], used: ["a"] }

iex> { game, tally } = Hangman.make_move(game, "b")
# ...

iex> tally
%{ game_state: :bad_guess, turns_left: 6, letters: ["_", "a", "_"], used: ["a", "b"] }

iex> { game, tally } = Hangman.make_move(game, "c")
# ...

iex> tally
%{ game_state: :good_guess, turns_left: 6, letters: ["c", "a", "_"], used: ["a", "b", "c"] }

iex> { game, tally } = Hangman.make_move(game, "t")
# ...

iex> tally
%{ game_state: :won, turns_left: 6, letters: ["c", "a", "t"], used: ["a", "b", "c", "t"] }
~~~

