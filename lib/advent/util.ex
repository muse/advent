defmodule Advent.Util do
  @moduledoc """
  Recurring common functionality between days.
  """

  defmodule Circular do
    @moduledoc false

    @doc """
    Reimplement &rem/2 behaviour with the exception of 0 being max.
    """
    @spec index(integer, integer) :: integer
    def index(index, max) do
      if index > max, do: index(index - max, max), else: index
    end

    @doc """
    Emulate any amount of numbers constricted to a numeric ceiling.
    """
    @spec between(integer, 0, integer) :: []
    def between(index, 0, max) do
      []
    end
    @spec between(integer, integer, integer) :: [integer, ...]
    def between(index, until, max) do
      index + 1..index + until
      |> Enum.reduce([], fn number, stack -> [index(number, max) | stack] end)
      |> Enum.reverse
    end
  end
end
