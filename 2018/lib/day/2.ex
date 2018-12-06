defmodule Day.InventoryManagementSystem do
  @moduledoc """
  https://adventofcode.com/2018/day/2
  """
  use Advent.Input, as: :row

  @typep wall :: {0 | 1, 0 | 1}
  @typep maze :: [wall]

  @typep id         :: <<_::216>>
  @typep alphabetic :: ?a..?z
  @typep occurances ::  0..3
  @typep allocator  :: %{alphabetic => occurances}

  @spec appraise(allocator | %{}, binary | <<>>) :: allocator | maze
  defp appraise(stack, <<character::binary-size(1), remainder::binary>>) do
    stack =
      case stack do
        %{^character => count} ->
          %{stack | character => count + 1}

        %{} ->
          Map.put(stack, character, 1)
      end

    appraise(stack, remainder)
  end

  defp appraise(stack, <<>>) do
    Enum.reduce(stack, {0, 0}, fn
      {_, 2}, {0, number} ->
        {1, number}

      {_, 3}, {number, 0} ->
        {number, 1}

      {_, _}, accumulator ->
        accumulator
    end)
  end

  @spec one(maze, [id] | []) :: integer
  defp one(stack, [id | remainder]) do
    one([appraise(%{}, id) | stack], remainder)
  end

  defp one(stack, []) do
    {double, triple} =
      Enum.reduce(stack, {0, 0}, fn
        {n,  m},
        {ns, ms} ->
          {ns + n,
           ms + m}
      end)

    Kernel.*(double, triple)
  end

  # Alternative solution to 2/2 is to use the 'Jaro Distance' or
  # 'Myers Difference' to calculate the string difference rather than manual
  # comparison, (but that is boring).
  #
  #    Jaro x, y: > 0.95
  #               = 0.961025641025641
  #   Myers x, y: = [ eq: left,
  #                  del: <<_::binary-size(1)>>,
  #                   eq: right,
  #                  ins: <<_::binary-size(1)>>]
  #

  @spec collector(binary, id, id) :: binary
  defp collector(id, <<character::binary-size(1), left::binary>>,
                    <<character::binary-size(1), right::binary>>) do
    collector(id <> character, left, right)
  end

  defp collector(id, <<_::binary-size(1), left::binary>>,
                    <<_::binary-size(1), right::binary>>) do
    collector(id, left, right)
  end

  defp collector(id, <<>>, <<>>) do
    id
  end

  @spec two(binary, [id] | []) :: binary
  defp two(<<id::binary-size(25)>>, _) do
    id
  end

  defp two(<<_::binary>>, [id | remainder]) do
    id =
      Enum.reduce(@input, "", fn
        ^id, accumulator ->
          accumulator

        _, <<id::binary-size(25)>> ->
          id

        iteration, _ ->
          collector("", id, iteration)
      end)

    two(id, remainder)
  end

  @doc false
  @spec main :: Keyword.t()
  def main do
    [one: one([], @input),
     two: two("", @input)]
  end
end
