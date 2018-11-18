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
