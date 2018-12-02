defmodule FrequencyChanges do
  def read(file) do
    {:ok, data} = File.read(file)
    
    data
    |> String.split("\n")
    |> Enum.map(fn val -> String.to_integer(val) end)
  end

  def compute_changes(file) do
    read(file)
    |> Enum.reduce(fn val, acc -> val + acc end)
  end
end