
defmodule IdsChecksum do
  def read(file) do
    {:ok, data} = File.read(file)
    data
    |> String.trim_trailing("\n")
    |> String.split("\n")
  end

  def compute_checksum(file), do: compute_checksum(read(file), 0, 0)
  def compute_checksum([], two_count, three_count), do: two_count * three_count
  def compute_checksum([h | t], two_count, three_count) do
    counts = h
    |> String.to_charlist
    |> Enum.reduce(%{}, fn char, acc -> Map.put(acc, char, (acc[char] || 0) + 1) end)
    |> Map.values
    
    cond do
      Enum.member?(counts, 3) && Enum.member?(counts, 2) -> compute_checksum(t, two_count + 1, three_count + 1)
      Enum.member?(counts, 3) -> compute_checksum(t, two_count, three_count + 1)
      Enum.member?(counts, 2) -> compute_checksum(t, two_count + 1, three_count)
      true -> compute_checksum(t, two_count, three_count)
    end
  end

  def find_similar_ids(file) do
    [h | t] = read(file) |> Enum.map(fn v -> String.to_charlist(v) end)
    compare_ids(h, t, t)
  end

  def compare_ids(_, [_ | []], [h | t]), do: compare_ids(h, t, t)
  def compare_ids(id1, [id2 | t], values) do
    case Enum.count(id2) - Enum.count(strings_delta(id1, id2)) do
      1 -> Enum.reverse(strings_delta(id1, id2))
      _ -> compare_ids(id1, t, values)
    end
  end

  def strings_delta(string1, string2, list \\ [])
  def strings_delta([h1 | t1], [h2 | t2], list) do
    case h1 != h2 do
      true -> strings_delta(t1, t2, list)
      false -> strings_delta(t1, t2, [h1 | list])
    end
  end

  def strings_delta(_, _, list), do: list
end