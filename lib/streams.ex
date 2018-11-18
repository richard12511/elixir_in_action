defmodule Streams do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 80))
  end

  def lines_length!(path) do
    File.stream!(path)
    |> Stream.with_index
    |> Enum.map(fn {line, index} -> {index + 1, String.length(line)} end)
  end

  def longest_line_length!(path) do
    File.stream!(path)
    |> Enum.reduce(0, &longest_val/2)
  end

  def longest_line(path) do
    File.stream!(path)
    |> Enum.reduce("", &longest_line/2)
  end

  defp longest_val(line, val) do
    if String.length(line) > val, do: String.length(line), else: val
  end

  defp longest_line(new_line, longest_line) do
    case String.length(new_line) > String.length(longest_line) do
      true -> new_line
      false -> longest_line
    end
  end
end