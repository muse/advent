defmodule Day.StreamProcessing do
  @moduledoc """
  9/1
  A large stream blocks your path. According to the locals, it's not safe to
  cross the stream at the moment because it's full of garbage. You look down at
  the stream; rather than water, you discover that it's a stream of characters.

  You sit for a while and record part of the stream (your puzzle input). The
  characters represent groups - sequences that begin with { and end with }.
  Within a group, there are zero or more other things, separated by commas:
  either another group or garbage. Since groups can contain other groups, a }
  only closes the most-recently-opened unclosed group - that is, they are
  nestable. Your puzzle input represents a single, large group which itself
  contains many smaller ones.

  Sometimes, instead of a group, you will find garbage. Garbage begins with < and
  ends with >. Between those angle brackets, almost any character can appear,
  including { and }. Within garbage, < has no special meaning.

  In a futile attempt to clean up the garbage, some program has canceled some of
  the characters within it using !: inside garbage, any character that comes
  after ! should be ignored, including <, >, and even another !.

  You don't see any characters that deviate from these rules. Outside garbage, you
  only find well-formed groups, and garbage always terminates according to the
  rules above.

  What is the total score for all groups in your input?

  9/2
  Now, you're ready to remove the garbage.

  To prove you've removed it, you need to count all of the characters within the
  garbage. The leading and trailing < and > don't count, nor do any canceled
  characters or the ! doing the canceling.

  How many non-canceled characters are within the garbage in your puzzle input?
  """

  use Advent.Input, as: :plain

  @input @input
  |> String.to_charlist

  defmodule Group do
    defstruct value: [], trash: [], children: []

    @type t :: %__MODULE__{}
  end

  defmodule Garbage do
    defstruct value: []

    @type t :: %__MODULE__{}
  end

  @spec prepend(:<> | :{}, Group.t, integer, list) :: list
  defp prepend(which, from, value, to) do
    [{transform(which, from, value), value} | to]
  end

  @spec transform(list, :{}) :: list
  defp transform(tree, :{}) do
    transform(:{}, tree, 0)
  end
  @spec transform(list, :<>) :: list
  defp transform(tree, :<>) do
    transform(:<>, tree, 0)
  end
  @spec transform(:<>, Group.t, integer) :: list
  defp transform(:<>, %Group{children: children, trash: trash}, _amount) do
    amount =
      Enum.reduce(trash, 0, fn %Garbage{value: value}, stack ->
        stack + length(value)
      end)
    case children do
      [] -> [{[], amount}]
       _ -> Enum.reduce(children, [], & prepend(:<>, &1, amount, &2))
    end
  end
  @spec transform(:{}, Group.t, integer) :: list
  defp transform(:{}, %Group{children: children}, depth) do
    Enum.reduce(children, [], & prepend(:{}, &1, depth + 1, &2))
  end

  defp count(tree, collective \\ 0)
  @spec count({list, integer}, list) :: list
  defp count({remainder, number} = tree, collective) when is_tuple(tree) do
    count(remainder, collective + number)
  end
  @spec count(list, list) :: list
  defp count(tree, collective) when is_list(tree) do
    Enum.reduce(tree, collective, fn branch, collective ->
      collective + count(branch, 0)
    end)
  end
  @spec count([], list) :: list
  defp count([], collective) do
    collective
  end

  @spec parse(charlist) :: list
  defp parse(characters) do
    parse(:{}, characters, %Group{})
  end
  @spec parse(:<>, charlist, Garbage.t) :: {Garbage.t, charlist}
  defp parse(:<>, [?!, _ | characters], garbage) do
    parse(:<>, characters, garbage)
  end
  defp parse(:<>, [?> | characters], %Garbage{value: value} = garbage) do
    {%{garbage | value: Enum.reverse(value)}, characters}
  end
  defp parse(:<>, [character | characters], %Garbage{value: value} = garbage) do
    parse(:<>, characters, %{garbage | value: [character | value]})
  end
  @spec parse(:{}, charlist, Group.t) :: {Group.t, charlist}
  defp parse(:{}, [?{ | characters], %Group{children: children} = group) do
    {child, characters} = parse(:{}, characters, %Group{})
    parse(:{}, characters, %{group | children: [child | children]})
  end
  defp parse(:{}, [?} | characters], %Group{value: value} = group) do
    {%{group | value: Enum.reverse(value)}, characters}
  end
  defp parse(:{}, [?< | characters], %Group{trash: trash} = group) do
    {garbage, characters} = parse(:<>, characters, %Garbage{})
    parse(:{}, characters, %{group | trash: [garbage | trash]})
  end
  defp parse(:{}, [character | characters], %Group{value: value} = group) do
    parse(:{}, characters, %{group | value: [character | value]})
  end
  @spec parse(:{}, [], Group.t) :: Group.t
  defp parse(:{}, [], group) do
    group
  end

  def one(characters) do
    characters |> parse |> transform(:{}) |> count
  end
  def two(characters) do
    characters |> parse |> transform(:<>) |> count
  end

  def main() do
    # Answer
    [one: one(@input), two: two(@input)]
  end
end
