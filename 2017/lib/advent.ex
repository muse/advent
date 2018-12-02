defmodule Advent do
  @moduledoc false

  alias Day.{
    InverseCaptcha,
    CorruptionChecksum,
    SpiralMemory,
    HighEntropyPassphrase,
    AMOTTAA,
    MemoryReallocation,
    RecursiveCircus,
    IHYLR,
    StreamProcessing,
    KnotHash
  }

  @days %{
    1 => InverseCaptcha,
    2 => CorruptionChecksum,
    3 => SpiralMemory,
    4 => HighEntropyPassphrase,
    5 => AMOTTAA,
    6 => MemoryReallocation,
    7 => RecursiveCircus,
    8 => IHYLR,
    9 => StreamProcessing,
   10 => KnotHash
  }

  @spec day(integer | Range.t | :all) :: map
  defp day(days) do
    case days do
      %Range{} = day ->
        Map.take(@days, Enum.to_list(day))
      :all ->
        @days
      day ->
        Map.take(@days, [day])
    end
  end

  @spec main(integer | Range.t | :all) :: [[one: integer, two: integer], ...]
  def main(days) do
    for {_, module} <- day(days), do: apply(module, :main, [])
  end
end
