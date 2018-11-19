defmodule TodoServer do
  def start do
    spawn(fn -> loop(TodoList.new) end)
  end

  def entries(server_pid, date) do
    send(server_pid, {:entries, self(), date})
    receive do
      {:response, entries} -> entries
    end
  end

  def add_entry(server_pid, entry) do
    send(server_pid, {:add_entry, entry})
  end

  defp loop(todo_list) do
    new_todo_list = receive do
      message -> process_message(todo_list, message)
    end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:response, TodoList.entries(todo_list, date)})
  end

  defp process_message(todo_list, {:add_entry, entry}), do: TodoList.add_entry(todo_list, entry)
  defp process_message(todo_list, {:update_entry, entry}), do: TodoList.update_entry(todo_list, entry)
end

defmodule TodoList do
  defstruct auto_id: 1, entries: HashDict.new


  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn(entry, acc) ->
        add_entry(acc, entry)
      end
    )
  end

  def new_from_file(path) do
    File.stream!(path)
    |> Stream.map(fn line -> String.replace(line, "\n", "") end)
    |> Stream.map(fn line -> line_to_entry(line) end)
    |> new

  end

  def add_entry(%TodoList{entries: entries, auto_id: auto_id} = todo_list, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = HashDict.put(entries, auto_id, entry)

    %TodoList{todo_list | entries: new_entries, auto_id: auto_id + 1}
  end

  def entries(%TodoList{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, entry}) -> entry.date == date end)
    |> Enum.map(fn({_, entry}) -> entry end)
  end

  def all_entries(%TodoList{entries: entries}) do
    entries
  end

  def update_entry(%TodoList{entries: entries} = todo_list, entry_id, updater_fun) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = HashDict.put(entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  defp line_to_entry(line) do
    line_list = String.split(line, ",")
    date_str = Enum.at(line_list, 0)
    title_str = Enum.at(line_list, 1)

    %{date: parse_date(date_str), title: title_str}
  end

  defp parse_date(date) do
    date_list = String.split(date, "/")
    year = date_list |> Enum.at(0) |> String.to_integer
    month = date_list |> Enum.at(1) |> String.to_integer
    day = date_list |> Enum.at(2) |> String.to_integer

    {year, month, day}
  end
end
