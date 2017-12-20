defmodule Day.HighEntropyPassphrase do
  @moduledoc """
  4/1
  A new system policy has been put in place that requires all accounts to use a
  passphrase instead of simply a password. A passphrase consists of a series of
  words (lowercase letters) separated by spaces.

  To ensure security, a valid passphrase must contain no duplicate words.

  4/2
  For added security, yet another system policy has been put in place. Now, a
  valid passphrase must contain no two words that are anagrams of each other -
  that is, a passphrase is invalid if any word's letters can be rearranged to
  form any other word in the passphrase.
  """

  use Advent.Input, as: :row

  @input @input
  |> Enum.map(fn row ->
       String.split(row, " ", trim: true)
     end)

  @spec uniq([binary, ...]) :: boolean
  defp uniq(row) do
    row |> Enum.uniq |> length === row |> length
  end

  @spec sort(binary) :: binary
  defp sort(word) when is_binary(word) do
    word |> String.split("") |> Enum.sort |> Enum.join
  end
  @spec sort([binary, ...]) :: boolean
  defp sort(row) do
    row |> Enum.map(&sort/1) |> Enum.uniq |> length === row |> length
  end

  @spec one([[binary, ...], ...], integer) :: integer
  defp one([row | rows], stack) do
    one(rows, stack + (if uniq(row), do: 1, else: 0))
  end
  @spec one([], integer) :: integer
  defp one([], stack) do
    stack
  end

  @spec two([[binary, ...], ...], integer) :: integer
  defp two([row | rows], stack) do
    two(rows, stack + (if sort(row), do: 1, else: 0))
  end
  @spec two([], integer) :: integer
  defp two([], stack) do
    stack
  end

  def main() do
    # Answer
    [one: one(@input, 0), two: two(@input, 0)]
  end
end
