defmodule MagiratorStore.Stores.ResultStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Structs.Result
  alias MagiratorStore.Helpers

  import MagiratorStore.Stores.IdStore
  import Ecto.Changeset

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


  def select_all_by_deck( deck_id ) do

    query = """
    MATCH 
      (r:Result)-[:With]->(d:Deck)
    WHERE 
      d.id = #{ deck_id } 
    RETURN 
      r
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
    result_map = node["r"].properties

    if Result.map_has_valid_values? result_map do
      Helpers.atomize_keys result_map
    else
      { :error, :invalid_data }
    end
  end
end