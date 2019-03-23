defmodule MagiratorStoreTest do
  use ExUnit.Case
  
  import MagiratorStore
  alias MagiratorStore.Structs.Deck
  alias MagiratorStore.Structs.Game
  alias MagiratorStore.Structs.Result
  alias MagiratorStore.Structs.Match
  alias MagiratorStore.Structs.Participant


  test "Create deck" do
    deck = %Deck{ 
    name: "StoreTestCreateDeck" , 
    theme: "themy", 
    format: "formaty", 
    black: :true, 
    white: :false, 
    red: :false, 
    green: :false, 
    blue: :false, 
    colorless: :false, 
    }

    { status, id } = create_deck(deck, 12)
    assert :ok == status
    assert is_number id
  end


  test "Select all decks" do
    { status, data } = list_decks()
    assert :ok == status
    assert is_list data
    assert not Enum.empty? data
  end


  test "Create game" do
    game = %Game{ 
      conclusion: "VICTORY", 
      created: System.system_time(:second), 
      creator_id: 10,
    }
    { status, id } = create_game( game )
    assert :ok == status
    assert is_number id
  end


  test "Select deck by id" do
    { status, data } = get_deck 20
    assert :ok == status
    assert data.name == "Deck 1"
  end

  test "Select deck not exist" do
    { status, msg } = get_deck 99
    assert :error == status
    assert :not_found == msg
  end


  test "Create user" do
    { status, id } = create_user("User 1", "Xyz123")
    assert :ok == status
    assert is_number id
  end


  test "Create player" do
    { status, id } = create_player("Player 1", 1)
    assert :ok == status
    assert is_number id
  end

  test "Select all players" do
    { status, data } = list_players()
    assert :ok == status
    assert is_list data
    assert not Enum.empty? data
  end


  test "Add results" do
    result1 = %Result{
        game_id: 42,
        player_id: 12,
        deck_id: 23,
        place: 1,
        comment: "Add result 1"
      }

    { status, id } = add_result( result1 )
    assert :ok == status
    assert is_number id
    
    result2 = %Result{
        game_id: 42,
        player_id: 10,
        deck_id: 20,
        place: 2,
        comment: "Add result 2"
      }

    { status, id } = add_result( result2 )
    assert :ok == status
    assert is_number id
  end

  test "List results" do
    { status, data } = list_results_by_deck 20
    assert :ok == status
    assert Enum.count(data) > 0
    assert Enum.at(data, 0) |> Map.has_key?(:place)
    assert Enum.at(data, 0) |> Map.has_key?(:player_id)
    assert Enum.at(data, 0) |> Map.has_key?(:deck_id)
    assert Enum.at(data, 0) |> Map.has_key?(:game_id)
  end

  test "Get results in game" do
    { status, data } = list_results_by_game 40
    assert :ok == status
    assert Enum.count(data) > 0
    assert Enum.at(data, 0) |> Map.has_key?(:place)
    assert Enum.at(data, 0) |> Map.has_key?(:place)
    assert Enum.at(data, 0) |> Map.has_key?(:player_id)
    assert Enum.at(data, 0) |> Map.has_key?(:deck_id)
    assert Enum.at(data, 0) |> Map.has_key?(:game_id)
  end


  test "Create match" do
    match = %Match{
      created: System.system_time(:second), 
      creator_id: 12
    }
    { status, mid } = create_match( match )
    assert :ok == status
    assert is_number mid
  end

  test "get match" do
    { status, data } = get_match(50)
    assert :ok == status
    assert data.id == 50
  end

  test "select games in match" do
    { status, data } = get_games_in_match(50)
    assert :ok == status
    assert is_list data
    assert not Enum.empty? data
  end


  test "create participant" do
    participant = %Participant{
      player_id: 12, 
      deck_id: 23, 
      number: 1
    }
    { status, id } = create_participant(participant, 50)
    assert :ok == status
    assert is_number id
  end

  test "select participants in match" do
    { status, data } = list_participants_by_match(50)
    assert :ok == status
    assert is_list data
    assert not Enum.empty? data
  end


  test "add game to match" do
    { status } = add_game_to_match( 40, 50 )
    assert :ok == status
  end
end