defmodule DeckStoreTest do
  use ExUnit.Case

  import MagiratorStore.Stores.DeckStore
  alias MagiratorStore.Structs.Deck

  #Create
  test "Create deck" do
    deck_struct = %Deck{ 
      name: "DeckStoreTest" , 
      theme: "themy", 
      format: "formaty", 
      black: :false, 
      white: :false, 
      red: :false, 
      green: :true, 
      blue: :true, 
      colorless: :false, 
      }
    { status, id } = create( deck_struct, 10 )
    assert :ok == status
    assert is_number id
  end

  #Select
  #player
  test "Select player decks" do
    { status, data } = select_all_by_player 10
    assert :ok == status
    assert is_list data
    assert not Enum.empty? data
  end

  test "Select all decks player with no decks" do
    { status, data } = select_all_by_player 99
    assert :ok == status
    assert [] == data
  end

  #id
  test "Select deck by id" do
    { status, data } = select_by_id 20
    assert :ok == status
    assert data.name == "Deck 1"
  end

  test "Select deck not exist" do
    { status, msg } = select_by_id 99
    assert :error == status
    assert :not_found == msg
  end

  #all
  test "Select all decks" do
    { status, data } = select_all()
    assert :ok == status
    assert is_list data
    assert not Enum.empty? data
  end
end