defmodule MagiratorStore.NeoHelper do

  def as_labels(params) do
    params
    |> Enum.map(&as_label/1)
  end

  def as_label(label) when is_atom label do
    upcase = label
    |> Atom.to_string
    |> String.upcase()

    Enum.join([":", upcase])
  end

  def as_label(label) when is_bitstring label do
    upcase = label
    |> String.upcase()

    Enum.join([":", upcase])
  end

  def as_label_line(params) do
    params
    |> as_labels()
    |> Enum.join()
  end


  def extract_tags(node) do
    {_data, tags} =
      {node.labels, []}
      |> add_tier()
      |> add_arena()
    tags
  end

  defp add_tier({labels, list}) do
    case Enum.member?(labels, "TIER") do
      true -> {labels, list ++ [:tier]}
      _ -> {labels, list}
    end
  end

  defp add_arena({labels, list}) do
    case Enum.member?(labels, "ARENA") do
      true -> {labels, list ++ [:arena]}
      _ -> {labels, list}
    end
  end
end