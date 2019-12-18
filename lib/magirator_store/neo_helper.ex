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

  def as_label_line(params) do
    params
    |> as_labels()
    |> Enum.join()
  end
end