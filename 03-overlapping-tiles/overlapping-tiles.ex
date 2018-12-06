defmodule OverlappingTiles do

  def read(file) do
    {:ok, data} = File.read(file)
    data
    |> String.trim_trailing("\n")
    |> String.split("\n")
  end

  def parse_input(claim) do
    claim
    |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def compute_claimed_tiles(claims) do
    Enum.reduce(claims, %{}, fn claim, acc ->
      [id, left, top, width, height] = parse_input(claim)

      Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
        Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
          Map.update(acc, {x, y}, [id], &[id | &1])
        end)
      end)
    end)
  end

  def compute_overlapped_tiles(claims) do
    for {coord, [_, _ | _]} <- compute_claimed_tiles(claims), do: coord
  end

  def count_overlapping_claims(file) do
    read(file)
    |> compute_overlapped_tiles
    |> length
  end
end