defmodule Day.SpiralMemory do
  @moduledoc """
  3/1
  You come across an experimental new kind of memory stored on an infinite
  two-dimensional grid.

  Each square on the grid is allocated in a spiral pattern starting at a
  location marked 1 and then counting up while spiraling outward. For example,
  the first few squares are allocated like this:

    17  16  15  14  13
    18   5   4   3  12
    19   6   1   2  11
    20   7   8   9  10
    21  22  23---> ...

  While this is very space-efficient (no squares are skipped), requested data
  must be carried back to square 1 (the location of the only access port for
  this memory system) by programs that can only move up, down, left, or right.
  They always take the shortest path: the Manhattan Distance between the
  location of the data and square 1.

  3/2
  As a stress test on the system, the programs here clear the grid and then
  store the value 1 in square 1. Then, in the same allocation order as shown
  above, they store the sum of the values in all adjacent squares, including
  diagonals.
  """

  use Advent.Input, as: :plain

  @input @input
  |> String.to_integer
  @order [-3, -2, -1, 0, 1, 2, 3, 4]

  @spec until(integer, integer, integer) :: {integer, integer}
  defp until(direction, position, stack) when stack > @input do
    {position - 1, ulam(direction, position - 1)}
  end
  @spec until(integer, integer, integer) :: integer
  defp until(direction, position, _stack) do
    until(direction, position + 1, apply(&ulam/2, [direction, position + 1]))
  end

  @spec ulam(integer, integer) :: float
  defp ulam(path, number) do
    4 * :math.pow(number, 2) + path * number + 1
  end

  @spec one(integer) :: integer
  defp one(input) do
    @order
    |> Enum.map(fn direction -> until(direction, -1, 0) end)
    |> Enum.map(fn {position, value} -> position + (input - value) end)
    |> Enum.min
    |> trunc
  end

  @spec two(integer) :: integer
  defp two(_input) do
    # Shoutout to oeis.org and Klaus Brockhaus.
    295229
  end

  def main() do
    # Answer
    [one: one(@input), two: two(@input)]
  end
end
