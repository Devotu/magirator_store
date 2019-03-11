defmodule ResultStoreTest do
  use ExUnit.Case

  import MagiratorStore.Stores.ResultStore

  #Insert
  test "Create result" do
    result = %{ 
      player_id: 12, 
      game_id: 40,
      deck_id: 23,
      place: 3,
      comment: "ResultStore.create"
    }
    { status, id } = add( result )
    assert :ok == status
    assert is_number id
  end

  #List
  test "List results" do
    { status, data } = select_all_by_deck 20
    assert :ok == status
    assert Enum.count(data) > 0
    assert Enum.at(data, 0) |> Map.has_key?(:place)
  end

  test "List results - no such deck" do
    { status, data } = select_all_by_deck 10
    assert :ok == status
    assert Enum.count(data) == 0
  end
end