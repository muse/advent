defmodule Day.IHYLR do
  @moduledoc """
  8/1
  You receive a signal directly from the CPU. Because of your recent assistance
  with jump instructions, it would like you to compute the result of a series of
  unusual register instructions.

  Each instruction consists of several parts: the register to modify, whether to
  increase or decrease that register's value, the amount by which to increase or
  decrease it, and a condition. If the condition fails, skip the instruction
  without modifying the register. The registers all start at 0. The instructions
  look like this:

  8/2
  To be safe, the CPU also needs to know the highest value held in any register
  during this process so that it can decide how much memory to allocate to these
  operations. For example, in the above instructions, the highest value ever
  held was 10 (in register c after the third instruction was evaluated).
  """

  use Advent.Input, as: :row

  @input @input
  |> Enum.map(&String.split(&1, " "))

  @typep crementer   :: :+ | :-
  @typep operator    :: :eq | :ne | :lt | :le | :gt | :ge
  @typep variable    :: binary
  @typep instruction :: %{
      variable: variable,
     condition: {operator, {variable, integer}},
    expression: {crementer, integer}
  }
  @typep memory      :: %{integer => integer}

  @spec crement(binary) :: crementer
  defp crement("inc"), do: :+
  defp crement("dec"), do: :-

  @spec operate(binary) :: operator
  defp operate("=="), do: :eq
  defp operate("!="), do: :ne
  defp operate("<"),  do: :lt
  defp operate("<="), do: :le
  defp operate(">"),  do: :gt
  defp operate(">="), do: :ge

  @spec condition(operator, {integer, integer}) :: boolean
  defp condition(:eq, {left, right}), do: left == right
  defp condition(:ne, {left, right}), do: left != right
  defp condition(:lt, {left, right}), do: left <  right
  defp condition(:le, {left, right}), do: left <= right
  defp condition(:gt, {left, right}), do: left >  right
  defp condition(:ge, {left, right}), do: left >= right

  @spec expression(memory, variable, {crementer, integer}) :: memory
  defp expression(memory, variable, {crementer, value}) do
    Map.put(memory, variable, apply(Kernel, crementer, [memory[variable], value]))
  end

  @spec instruct([binary, ...]) :: instruction
  defp instruct([first, crementer, value, "if", second, operator, third] = row) do
    %{
        variable: first,
      expression: {crement(crementer), String.to_integer(value)},
       condition: {operate(operator), {second, String.to_integer(third)}}
     }
  end

  @spec default(memory, variable) :: memory
  defp default(memory, key) do
    if ! memory[key], do: Map.put(memory, key, 0), else: memory
  end

  @spec pair(memory, {variable, integer}) :: {integer, integer}
  defp pair(memory, {left, right}) do
    {memory[left], right}
  end

  @spec max(memory) :: integer
  defp max(memory) do
    {_, value} =
      Enum.max_by(memory, fn {_, value} ->
        value
      end)
    value
  end

  @spec evaluate(memory, instruction) :: memory
  defp evaluate(memory, %{variable: variable, condition: {operator, {left, right}}, expression: expression}) do
    memory = default(memory, variable)
    memory = default(memory, left)
      pair = pair(memory, {left, right})
    if condition(operator, pair) do
      expression(memory, variable, expression)
    else
      memory
    end
  end

  @spec one(memory, [instruction, ...]) :: memory
  defp one(memory, [instruction | instructions]) do
    memory |> evaluate(instruct(instruction)) |> one(instructions)
  end
  @spec one(memory, []) :: integer
  defp one(memory, []) do
    memory |> max
  end

  @spec two(memory, [instruction, ...], integer) :: memory
  defp two(memory, [instruction | instructions], high) do
     memory = memory |> evaluate(instruct(instruction))
    highest = memory |> max
    two(memory, instructions, if highest > high do highest else high end)
  end
  @spec two(memory, [], integer) :: integer
  defp two(memory, [], high) do
    high
  end

  def main() do
    # Answer
    [one: one(%{}, @input), two: two(%{}, @input, 0)]
  end
end

