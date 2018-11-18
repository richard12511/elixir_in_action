defmodule ListLength do

  def list_len([]) do
    0
  end

  def list_len([_head|tail]) do
    1 + list_len(tail)
  end

  def list_len_t(list) do
    calc_len(list, 0)
  end

  defp calc_len([], acc) do
    acc
  end

  defp calc_len([_head|tail], acc) do
    new_acc = 1 + acc
    calc_len(tail, new_acc)
  end
end
