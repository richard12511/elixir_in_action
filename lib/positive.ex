defmodule Positive do
  def positive([head | []]) when head >= 0 do
    [head]
  end

  def positive([_head | []]) do
    []
  end

  def positive([head | tail]) when head >= 0 do
    [head | positive(tail)]
  end

  def positive([_head | tail]) do
    positive(tail)
  end

  def positive_t(list) do
    calc_positive(list, [])
  end

  defp calc_positive([], acc) do
    acc |> Enum.reverse
  end

  defp calc_positive([head | tail], acc) when head >= 0 do
    new_acc = [head | acc]
    calc_positive(tail, new_acc)
  end

  defp calc_positive([_head | tail], acc) do
    calc_positive(tail, acc)
  end

end