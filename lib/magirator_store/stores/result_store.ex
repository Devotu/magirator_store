defmodule MagiratorStore.Stores.ResultStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Result

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



  #Helpers
  defp nodes_to_results( nodes ) do
      Enum.map( nodes, &node_to_result/1 )
  end

  defp node_to_result( node ) do

    result_changeset = Result.changeset( %Result{}, node["r"].properties )

    if result_changeset.valid? do
      apply_changes result_changeset
    else
      { :error, :invalid_data }
    end
  end
end