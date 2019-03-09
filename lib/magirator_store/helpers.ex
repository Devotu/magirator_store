defmodule MagiratorStore.Helpers do
  @doc """
  Convert map string keys to :atom keys
  """
  def atomize_keys(nil), do: nil

  # Structs don't do enumerable and anyway the keys are already
  # atoms
  def atomize_keys(struct = %{__struct__: _}) do
    struct
  end

  def atomize_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
  end


  def return_expected_single( list ) do
    case Enum.count list do
      1 ->
        Enum.fetch(list, 0)
      0 ->
        { :error, :not_found}
      _ ->
        { :error, :invalid_request}
    end
  end


  def return_as_tuple({:error, msg}) do
    {:error, msg}
  end

  def return_as_tuple(item) do
    {:ok, item}
  end
end