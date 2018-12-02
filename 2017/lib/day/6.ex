defmodule Day.MemoryReallocation do
  @moduledoc """
  6/1
  A debugger program here is having an issue: it is trying to repair a memory
  reallocation routine, but it keeps getting stuck in an infinite loop.

  In this area, there are sixteen memory banks; each memory bank can hold any
  number of blocks. The goal of the reallocation routine is to balance the
  blocks between the memory banks.

  The reallocation routine operates in cycles. In each cycle, it finds the
  memory bank with the most blocks (ties won by the lowest-numbered memory bank)
  and redistributes those blocks among the banks. To do this, it removes all of
  the blocks from the selected bank, then moves to the next (by index) memory
  bank and inserts one of the blocks. It continues doing this until it runs out
  of blocks; if it reaches the last memory bank, it wraps around to the first
  one.

  The debugger would like to know how many redistributions can be done before a
  blocks-in-banks configuration is produced that has been seen before.

  6/2
  Out of curiosity, the debugger would also like to know the size of the loop:
  starting from a state that has already been seen, how many block
  redistribution cycles must be performed before that same state is seen again?
  """

  use Advent.Input, as: :column

  @input @input
  |> Enum.with_index
  |> Enum.reduce(%{}, fn {register, index}, stack ->
       Map.put(stack, index, String.to_integer(register))
     end)

  @size @input
  |> Map.keys
  |> length
  |> Kernel.-(1)

  @typep action   :: :one | :two
  @typep register :: %{integer => integer} | {integer, integer}
  @typep memory   :: %{
    registers: register,
       action: action,
        loops: integer,
        index: integer,
        count: integer,
         left: integer,
         seen: [register, ...]
  }

  @spec next([register, ...]) :: register
  defp next(registers) do
    Enum.max_by(registers, fn {_index, register} ->
      register
    end)
  end

  @spec spread(memory) :: integer
  defp spread(memory = %{registers: registers, seen: seen, left: 0, loops: loops, action: action, count: count}) do
    {index, blocks} = next(registers)
              seen? = registers in seen
    cond do
      action === :one and seen? ->
        loops
      action === :one ->
        spread(%{
          memory |
            registers: %{registers | index => 0},
                loops: loops + 1,
                index: index + 1,
                 seen: [registers | seen],
                 left: blocks
        })
      action === :two and count === 2 ->
        loops - 1
      action === :two ->
        {count, seen} = if seen?, do: {count + 1, [seen]}, else: {count, [registers | seen]}
                loops = if count === 1, do: loops + 1, else: loops
        spread(%{
          memory |
            registers: %{registers | index => 0},
                count: count,
                loops: loops,
                index: index + 1,
                 left: blocks,
                 seen: seen
        })
    end
  end
  @spec spread(memory) :: integer
  defp spread(memory = %{index: index}) when index > @size do
    spread(%{memory | index: 0})
  end
  @spec spread(memory) :: integer
  defp spread(memory = %{registers: registers, index: index, left: left}) do
    spread(%{
      memory |
        registers: %{registers | index => registers[index] + 1},
            index: index + 1,
             left: left - 1
    })
  end

  @spec one([register, ...]) :: integer
  defp one(input) do
    spread(%{
      registers: input,
         action: :one,
          count: 0,
          loops: 0,
          index: nil,
           seen: [],
           left: 0
    })
  end

  @spec two([register, ...]) :: integer
  defp two(input) do
    spread(%{
      registers: input,
         action: :two,
          count: 0,
          loops: 0,
          index: nil,
           seen: [],
           left: 0
    })
  end

  def main() do
    # Answer
    [one: one(@input), two: two(@input)]
  end
end
