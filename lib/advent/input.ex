defmodule Advent.Input do
  @moduledoc """
  Include the required @input automatically and perform additional formatting.
  """

  defmacro __using__(opts) do
    quote do
      @input unquote(opts[:as]) |> Advent.Input.format(__ENV__.file)
    end
  end

  @spec prepare(binary) :: binary
  defp prepare(file) do
    "srv/#{file |> Path.basename(".ex")}.in"
  end

  @spec read!(binary) :: binary
  defp read!(file) do
    file |> prepare |> File.read! |> String.trim |> String.replace(~r/[\t\r]/, "\s")
  end

  @doc """
  Trimming, Replacing \t\r with \s.
  """
  @spec format(:plain, binary) :: binary
  def format(:plain, file) do
    file |> read!
  end
  @doc """
  Trimming, Replacing \t\r with \s, Split on \n.
  """
  @spec format(:row, binary) :: [binary, ...]
  def format(:row, file) do
    file |> read! |> String.split(~r/\n/, trim: true)
  end
  @doc """
  Trimming, Replacing \t\r with \s, Split on \n\s.
  """
  @spec format(:column, binary) :: [binary, ...]
  def format(:column, file) do
    file |> read! |> String.split(~r/[\n\s]/, trim: true)
  end
  @doc """
  Trimming, Replacing \t\r with \s, Replacing \n\s with "", Split on "".
  """
  @spec format(:cell, binary) :: [binary, ...]
  def format(:cell, file) do
    file |> read! |> String.replace(~r/[\n\s]/, "") |> String.split("", trim: true)
  end
end
