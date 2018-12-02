defmodule Day.CorruptionChecksum do
  @moduledoc """
  2/1
  As you walk through the door, a glowing humanoid shape yells in your direction.
  "You there! Your state appears to be idle. Come help us repair the corruption
  in this spreadsheet - if we take another millisecond, we'll have to
  display an hourglass cursor!"

  The spreadsheet consists of rows of apparently-random numbers. To make sure
  the recovery process is on the right track, they need you to calculate the
  spreadsheet's checksum. For each row, determine the difference between the
  largest value and the smallest value; the checksum is the sum of all of these
  differences.

  2/2
  "Great work; looks like we're on the right track after all. Here's a star for
  your effort." However, the program seems a little worried. Can programs be
  worried?

  "Based on what we're seeing, it looks like all the User wanted is some
  information about the evenly divisible values in the spreadsheet.
  Unfortunately, none of us are equipped for that kind of calculation - most of
  us specialize in bitwise operations."

  It sounds like the goal is to find the only two numbers in each row where one
  evenly divides the other - that is, where the result of the division operation
  is a whole number. They would like you to find those numbers on each line,
  divide them, and add up each line's result.
  """

  use Advent.Input, as: :row

  @input @input
  |> Enum.map(fn row ->
       Enum.map(String.split(row, " ", trim: true), &String.to_integer/1)
     end)

  @spec evenly?(float) :: boolean
  defp evenly?(number) when is_float(number) do
    # Explicit use of '==' to loosely compare Float -> Integer.
    if number == trunc(number), do: evenly?(trunc(number)), else: true
  end
  @spec evenly?(integer) :: boolean
  defp evenly?(_number) do
    false
  end

  @spec divisible([integer, ...], integer) :: integer
  defp divisible([number | numbers], stack) do
    case Enum.reject(numbers, &evenly?(&1 / number)) do
      [match] -> stack + match / number
           [] -> divisible(numbers, stack)
    end
  end
  defp divisible([], _stack) do
    raise "Unable to find an evenly divisible pair of numbers."
  end

  @spec one([[integer, ...], ...], integer) :: integer
  defp one([row | rows], stack) do
    one(rows, stack + (Enum.max(row) - Enum.min(row)))
  end
  @spec one([], integer) :: integer
  defp one([], stack) do
    stack
  end

  @spec two([[integer, ...], ...], integer) :: integer
  defp two([row | rows], stack) do
    two(rows, Enum.sort(row) |> divisible(stack))
  end
  @spec two([], integer) :: integer
  defp two([], stack) do
    trunc(stack)
  end

  def main() do
    # Answer
    [one: one(@input, 0), two: two(@input, 0)]
  end
end
