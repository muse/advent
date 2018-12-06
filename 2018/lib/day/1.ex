defmodule Day.ChronalCalibration do
  @moduledoc """
  https://adventofcode.com/2018/day/1
  """
  use Advent.Input, as: :row

  @input @input

  @typep state       :: integer
  @typep operator    :: (integer, integer -> integer)

  @typep recurrence  :: integer
  @typep recurrences :: %{recurrence => <<>>}

  @spec act(state, operator, integer) :: state
  defp act(state, operator, number) do
    case Integer.parse(number) do
      {number, _} ->
        operator.(state, number)
    end
  end

  @spec one(state, [binary] | []) :: state
  defp one(state, [<<"+", number::binary>> | remainder]) do
    state
    |> act(&Kernel.+/2, number)
    |> one(remainder)
  end

  defp one(state, [<<"-", number::binary>> | remainder]) do
    state
    |> act(&Kernel.-/2, number)
    |> one(remainder)
  end

  defp one(state, []) do
    state
  end

  @spec add(state, recurrences, [binary] | []) :: state
  defp add(state, recurrences, remainder) do
    case recurrences do
      %{^state => _} ->
         state

      %{} ->
        two(state, Map.put(recurrences, state, <<>>), remainder)
    end
  end

  @spec two(state, recurrences, [binary] | []) :: state
  defp two(state, recurrences, [<<"+", number::binary>> | remainder]) do
    state
    |> act(&Kernel.+/2, number)
    |> add(recurrences, remainder)
  end

  defp two(state, recurrences, [<<"-", number::binary>> | remainder]) do
    state
    |> act(&Kernel.-/2, number)
    |> add(recurrences, remainder)
  end

  defp two(state, recurrences, []) do
    two(state, recurrences, @input)
  end

  @doc false
  @spec main :: Keyword.t()
  def main do
    [one: one(0, @input),
     two: two(0, %{}, @input)]
  end
end
