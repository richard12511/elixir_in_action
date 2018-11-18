defmodule Range do
  def range(from, to) when from >= to do
    [from]
  end

  def range(from, to) when from < to do
    [from | range(from + 1, to)]
  end

  def range_t(from, to) do
    calc_range(from, to, [])
  end

  defp calc_range(from, to, acc) when length(acc) >= to do
    acc |> Enum.reverse
  end

  defp calc_range(from, to, acc) do
    new_acc = [from | acc]
    calc_range(from + 1, to, new_acc)
  end
end