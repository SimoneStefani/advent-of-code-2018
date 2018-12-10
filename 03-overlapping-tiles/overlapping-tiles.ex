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

  def compute_claimed_tiles(parsed_claims) do
    Enum.reduce(parsed_claims, %{}, fn [id, left, top, width, height], acc ->
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

  def compute_non_overlapping_tile(parsed_claims) do
    overlap = compute_claimed_tiles(parsed_claims)

    [id, _, _, _, _] =
      Enum.find(parsed_claims, fn [id, left, top, width, height] ->
        Enum.all?((left + 1)..(left + width), fn x ->
          Enum.all?((top + 1)..(top + height), fn y ->
            Map.get(overlap, {x, y}) == [id]
          end)
        end)
      end)
    
    id
  end

  def count_overlapping_claims(file) do
    read(file)
    |> Enum.map(&parse_input/1)
    |> compute_overlapped_tiles
    |> length
  end

  def find_non_overlapping_claim(file) do
    read(file)
    |> Enum.map(&parse_input/1)
    |> compute_non_overlapping_tile
  end
end