defmodule Day.AMOTTAA do
  @moduledoc """
  5/1
  An urgent interrupt arrives from the CPU: it's trapped in a maze of jump
  instructions, and it would like assistance from any programs with spare cycles
  to help find the exit.

  The message includes a list of the offsets for each jump. Jumps are relative:
  -1 moves to the previous instruction, and 2 skips the next one. Start at the
  first instruction in the list. The goal is to follow the jumps until one leads
  outside the list.

  In addition, these instructions are a little strange; after each jump, the
  offset of that instruction increases by 1. So, if you come across an offset of
  3, you would move three instructions forward, but change it to a 4 for the
  next time it is encountered.

  5/2
  Now, the jumps are even stranger: after each jump, if the offset was three or
  more, instead decrease it by 1. Otherwise, increase it by 1 as before.

  Using this rule with the above example, the process now takes 10 steps, and
  the offset values after finding the exit are left as 2 3 2 3 -1.
  """

  use Advent.Input, as: :column

  @input @input
  |> Enum.with_index
  |> Enum.reduce(%{}, fn {instruction, index}, stack ->
       Map.put(stack, index, String.to_integer(instruction))
     end)

  @spec increment(map, integer) :: map
  defp increment(map, index) do
    Map.put(map, index, pull(map, index) + 1)
  end

  @spec decrement(map, integer) :: map
  defp decrement(map, index) do
    Map.put(map, index, pull(map, index) - 1)
  end

  @spec pull(map, integer) :: integer
  defp pull(map, index) do
    Map.get(map, index)
  end

  @spec update(:one, map, integer, integer) :: map
  defp update(:one, map, previous, _index) do
    increment(map, previous)
  end
  @spec update(:two, map, integer, integer) :: map
  defp update(:two, map, previous, index) do
    if index - previous > 2, do: decrement(map, previous), else: increment(map, previous)
  end

  @spec step(:one | :two, map, integer, nil, integer) :: integer
  defp step(_which, _map, _index, nil, stack) do
    stack
  end
  @spec step(:one | :two, map, integer, integer, integer) :: integer
  defp step(which, map, index, instruction, stack) do
       previous = index
          index = index + instruction
            map = update(which, map, previous, index)
    instruction = pull(map, index)
          stack = stack + 1
    step(which, map, index, instruction, stack)
  end

  @spec one(map) :: integer
  defp one(input) do
    step(:one, input, 0, pull(input, 0), 0)
  end

  @spec two(map) :: integer
  defp two(input) do
    step(:two, input, 0, pull(input, 0), 0)
  end

  def main() do
    # Answer
    [one: one(@input), two: two(@input)]
  end
end
