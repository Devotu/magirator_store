defmodule MagiratorStore.Stores.ResultStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Structs.Result
  alias MagiratorStore.Helpers
  alias MagiratorStore.NeoHelper

  import MagiratorStore.Stores.IdStore

  def add( result ) do
    
    { :ok, generated_id } = next_id()

    query = """
      MATCH 
        (p:Player) 
        , (g:Game)
        , (d:Deck)
      WHERE 
        p.id = #{ result.player_id } 
        AND g.id = #{ result.game_id } 
        AND d.id = #{ result.deck_id } 
      CREATE
        (r:Result { 
          id:#{ generated_id }, 
          place:#{ result.place }, 
          created:TIMESTAMP(), 
          comment: "#{ result.comment }" 
          })
        , (p)-[:Got]->(r) 
        , (r)-[:In]->(g) 
        , (r)-[:With]->(d) 
      RETURN 
        r.id as id;
    """
    
    result = Bolt.query!(Bolt.conn, query)
    [ row ] = result
    { created_id } = { row["id"] }

    case created_id == generated_id do
      :true ->
        { :ok, created_id }
      :false ->
        { :error, :insert_failure }
    end
  end


  def select_all(tags) when is_list tags do

    tag_labels = NeoHelper.as_labels(tags)

    query = """
    MATCH 
      (p:Player)-[:Got]->
      (r:Result)-[:With]->(d:Deck),
      (r)-[:In]->(g:Game#{tag_labels})
    RETURN 
      r, 
      p.id AS player_id, 
      d.id AS deck_id, 
      g.id AS game_id 
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_results
    |> Helpers.return_as_tuple
  end

  def select_all() do

    query = """
    MATCH 
      (p:Player)-[:Got]->
      (r:Result)-[:With]->(d:Deck),
      (r)-[:In]->(g:Game)
    RETURN 
      r, 
      p.id AS player_id, 
      d.id AS deck_id, 
      g.id AS game_id 
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_results
    |> Helpers.return_as_tuple
  end


  def select_all_by_deck( deck_id ) do

    query = """
    MATCH 
      (p:Player)-[:Got]->
      (r:Result)-[:With]->(d:Deck),
      (r)-[:In]->(g:Game)
    WHERE 
      d.id = #{ deck_id } 
    RETURN 
      r, 
      p.id AS player_id, 
      d.id AS deck_id, 
      g.id AS game_id 
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_results
    |> Helpers.return_as_tuple
  end


  def select_all_by_game( game_id ) do

    query = """
    MATCH 
      (p:Player)-[:Got]->
      (r:Result)-[:With]->(d:Deck),
      (r)-[:In]->(g:Game)
    WHERE 
      g.id = #{ game_id } 
    RETURN 
      r, 
      p.id AS player_id, 
      d.id AS deck_id, 
      g.id AS game_id 
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_results
    |> Helpers.return_as_tuple
  end


  #Helpers
  defp nodes_to_results( nodes ) do
      Enum.map( nodes, &node_to_result/1 )
  end

  defp node_to_result( node ) do
    result = node["r"].properties
    player_id = node["player_id"]
    deck_id = node["deck_id"]
    game_id = node["game_id"]

    merged = Map.merge( %{"player_id" => player_id, "deck_id" => deck_id, "game_id" => game_id}, result )

    if Result.map_has_valid_values? merged do
      Helpers.atomize_keys merged
    else
      { :error, :invalid_data }
    end
  end
end