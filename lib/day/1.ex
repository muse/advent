defmodule Day.InverseCaptcha do
  @moduledoc """
  1/1
  You're standing in a room with "digitization quarantine" written in LEDs
  along one wall. The only door is locked, but it includes a small interface.
  "Restricted Area - Strictly No Digitized Users Allowed." It goes on to explain
  that you may only leave by solving a captcha to prove you're not a human.
  Apparently, you only get one millisecond to solve the captcha: too fast for a
  normal human, but it feels like hours to you.

  The captcha requires you to review a sequence of digits (your puzzle input)
  and find the sum of all digits that match the next digit in the list. The list
  is circular, so the digit after the last digit is the first digit in the list.

  1/2
  You notice a progress bar that jumps to 50% completion. Apparently, the door
  isn't yet satisfied, but it did emit a star as encouragement. The instructions
  change:

  Now, instead of considering the next digit, it wants you to consider the digit
  halfway around the circular list. That is, if your list contains 10 items,
  only include a digit in your sum if the digit 10/2 = 5 steps forward matches it.
  Fortunately, your list has an even number of elements.
  """

  use Advent.Input, as: :cell

  @input @input
  |> Enum.map(&String.to_integer/1)

  @spec circular(integer, integer) :: integer
  defp circular(step, distance) do
    if step > distance, do: circular(step - distance, distance), else: step
  end

  @spec one([integer, ...], %{}, 0) :: integer
  defp one([number | numbers], state, stack) when state === %{} do
    one(numbers, %{first: number, previous: number}, stack)
  end
  @spec one([integer, ...], %{first: integer, previous: integer}, integer) :: integer
  defp one([number | numbers], state, stack) do
    one(numbers, %{state | previous: number}, (if number === state[:previous], do: stack + number, else: stack))
  end
  @spec one([], %{first: integer, previous: integer}, integer) :: integer
  defp one([], state, stack) do
    if state[:first] === state[:previous], do: stack + state[:first], else: stack
  end

  @spec two([integer, ...], {integer, integer}, integer) :: integer
  defp two([number | numbers], {step, size}, stack) do
    two(numbers, {step + 1, size}, (if number === Enum.at(@input, circular(step, size)), do: stack + number, else: stack))
  end
  @spec two([], {integer, integer}, integer) :: integer
  defp two([], _, stack) do
    stack
  end

  def main() do
    size = length(@input)
    step = div(size, 2)

    # Answer
    [one: one(@input, %{}, 0), two: two(@input, {step, size}, 0)]
  end
end
