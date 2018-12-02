defmodule Day.RecursiveCircus do
  use Advent.Input, as: :row

  @input @input
  |> Enum.map(&String.split(&1, " "))

  def main() do
    # Answer
    [one: one(@input)]
  end

  def one(input) do
    memory = input |> parse(%{})
    # Enum.reduce(memory, [], fn {id, %{children: children, value: _value}}, stack ->

    #   if children do
    #     Enum.reduce(children, child ->
    #     end)
    #   else
    #     {id, 0}
    #   end
    # end)
  end

    # One ->
  #  Spawns Seeker to find Id and Id:Children.
  #
  # Seeker ->
  #  Finds the depth of each child.
  #
  # Chi
  #
  #
  #

  def seeker(memory, nil, step) do
    [id | _] = memory |> Map.keys
    seeker(memory, id, step)
  end
  def seeker(memory, id, step) do
    {target, step} = seek(:id, memory, id, step)
          children = seek(:children, memory, id)

    step =
      if children do
        Enum.reduce(children, step, fn child, stack ->
          stack + seeker(memory, child, step)
        end)
      else
        {id, step}
      end

    childs = seek(:children, memory, id)


    # if childs do
    #   Enum.reduce(childs, step, fn child, stack ->
    #     a + seeker(memory, child, 0)
    #   end)
    # else
    #   IO.inspect {id, step}
    #   step
    # end
  end
  def seek(:id, memory, id, step) do
    trgt = memory[id]
    if trgt do
      step + 1
    else
      step
    end
    {trgt, step}
  end
  def seek(:children, memory, id) do
    memory[id][:children]
  end

  def value(value) do
    with [value] <- String.split(value, ~r/[\(\)]/, trim: true),
         value <- String.to_integer(value),
    do: value
  end

  def parse([row | rows], stack) do
    stack =
      case row do
        [id, value] ->
          Map.put(stack, id, %{value: value(value), children: nil})
        [id, value, "->" | children] ->
          Map.put(stack, id, %{value: value(value), children: children})
      end
    parse(rows, stack)
  end
  def parse([], stack) do
    stack
  end

  # def find(memory, id, stack) do
  #   with   target <- memory[id],
  #        children <- target[:children]
  #   do
  #     {target, stack} =
  #       case {target, children} do
  #         # {nil, nil} ->
  #         #   # No target and no children, don't do anything with the stack.
  #         #   stack
  #         {target, nil} ->
  #           # Target was found but doesn't have children, increment with 1 and
  #           # leave at that.
  #           {target, stack + 1, nil}
  #         {target, children} ->
  #           {target, stack + 1, children}
  #
  #           # Target was found and has children, respawn finders for each child.
  #           # Enum.reduce(children, stack + 1, fn child, stack ->
  #           #   stack + find(memory, child, stack)
  #           # end)
  #       end
  #     {target, stack}
  #   end
  # end
  #
  # def hunter(memory, id, stack) do
  #   targets =
  #     memory
  #     |> Map.keys
  #
  #   Enum.reduce(targets, [], fn target, stacks ->
  #     # IO.inspect memory[target]
  #     # IO.inspect target
  #     [find(memory, target, stack) | stacks]
  #   end)
  #
  #
  #   # case find(memory, id, stack) do
  #   #   {stack, nil} ->
  #   #     stack
  #   #   {stack, children} ->
  #   #     Enum.
  #   # end
  # end
  #
  # def hq() do
  # end
  #
  # def one(input) do
  #   memory = parse(input, %{})
  #   hunter(memory, nil, 0)
  #
  #
  #   # # hunter = hunter
  #   # #   prey =
  #   #
  #   #
  #   # ids = input |> parse(%{})
  #   # keys = Map.keys(ids)
  #   # key = List.first(keys)
  #   #
  #   # seek(ids, key, 0)
  # end

  # Deep search all the children of a given program.
  # :a, [:b, :c]
  # :b, [:d, :e]
  # :c, [:f, :g]
  #
  #

  # def id() do
  #
  # end

  # def seek(input, key, stack) do
  #   with row      <- input[key],
  #        children <- row[:children]
  #   do
  #     IO.inspect row
  #     if children do
  #       {children, :ok}
  #       # for child <- children do
  #       #
  #       # end
  #     else
  #       {_, input} =
  #         Map.pop(input, key)
  #       {input, key, stack}
  #     end
  #   end
  # end
  # def seek(input, id) do
  #
  # end
end
