defmodule PlayerStoreTest do
  use ExUnit.Case
  
  import MagiratorStore.PlayerStore

  test "get user" do
    {:ok, player} = select_by_user_id(1)
    assert "Erlango" == player.name
    assert 10 == player.id
  end
end