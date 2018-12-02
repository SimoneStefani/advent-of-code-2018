defmodule FrequencyChanges do
  def read(file) do
    {:ok, data} = File.read(file)
    
    data
    |> String.split("\n")
    |> Enum.map(fn val -> String.to_integer(val) end)
  end

  def compute_changes(file) do
    read(file)
    |> Enum.sum
  end

  def first_repeated_frequency(file) do
    values = read(file)
    first_repeated_frequency(values, values, [], 0)
  end

  def first_repeated_frequency(values, [h | t], freqs, acc) do
    case Enum.member?(freqs, acc) do
      true -> acc
      false ->
        case t do
          [] -> 
            first_repeated_frequency(values, values, [acc | freqs], acc + h)
          _ ->
            first_repeated_frequency(values, t, [acc | freqs], acc + h)
        end
    end
  end
end