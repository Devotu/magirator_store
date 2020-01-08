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


  def return_expected_matching_id(created_id, generated_id) do
      case created_id == generated_id do
      :true ->
          { :ok, created_id }
      :false ->
          { :error, :insert_failure }
    end
  end


  def return_as_tuple({:error, msg}) do
    {:error, msg}
  end

  def return_as_tuple(item) do
    {:ok, item}
  end


  def return_result_id(response) do
    %{results: result} = response
    [ row ] = result
    { created_id } = { row["id"] }
    created_id
  end


  def only_atoms(list) when is_list list do
    Enum.map(list, &only_atom/1)
  end

  def only_atom(x) when is_atom x do
    x
  end


  def update_evaluation(%{stats: stats}, expect_updated) do
    case stats["properties-set"] == expect_updated do
      :true -> :ok
      _ -> {:error, :unexpected_result}
    end
  end
end