defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  def value(pid) do
    send(pid, {:value, self()})
    receive do
      {:response, value} -> value
    end
  end

  def add(pid, value) do
    send(pid, {:add, value})
  end

  def sub(pid, value) do
    send(pid, {:sub, value})
  end

  def mult(pid, value) do
    send(pid, {:mult, value})
  end

  def div(pid, value) do
    send(pid, {:div, value})
  end

  defp loop(current_value) do
    new_value = receive do
      {:value, caller} ->
        send(caller, {:response, current_value})
        current_value
      {:add, value} -> current_value + value
      {:sub, value} -> current_value - value
      {:mult, value} -> current_value * value
      {:div, value} -> current_value / value
      invalid_request ->
        IO.puts "invalid request #{inspect invalid_request}"
        current_value
    end

    loop(new_value)
  end
end