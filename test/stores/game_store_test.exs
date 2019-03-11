defmodule GameStoreTest do
  use ExUnit.Case

  import MagiratorStore.Stores.GameStore
  alias MagiratorStore.Structs.Game

  #Insert
  test "Create game" do
    game = %Game{ 
      conclusion: "VICTORY", 
      created: System.system_time(:second), 
      creator_id: 10,
    }
    { status, id } = create( game )
    assert :ok == status
    assert is_number id
  end
end
