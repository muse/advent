defmodule Advent do
  @moduledoc false

  alias Day.{
    ChronalCalibration,
    InventoryManagementSystem
  }

  @days %{
    1 => ChronalCalibration,
    2 => InventoryManagementSystem
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
