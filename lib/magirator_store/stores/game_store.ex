defmodule MagiratorStore.Stores.GameStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Helpers
  alias MagiratorStore.NeoHelper

  import MagiratorStore.Stores.IdStore

  def create( game ) do   
    { :ok, generated_id } = next_id()
    tags = NeoHelper.as_label_line(game.tags)

    query = """
      MATCH 
        (p:Player) 
      WHERE 
        p.id = #{ game.creator_id } 
      CREATE 
        (p)-[:Created]->(g:Game#{tags} { id:#{ generated_id }, created:TIMESTAMP(), conclusion: "#{ game.conclusion }" })
      RETURN 
        g.id as id;
    """
    
    %{results: result} = Bolt.query!(Bolt.conn, query)
    [ row ] = result
    { created_id } = { row["id"] }

    case created_id == generated_id do
      :true ->
        { :ok, created_id }
      :false ->
        { :error, :insert_failure }
    end
  end


  def select_by_id( game_id ) do
    query = """
    MATCH 
      (g:Game) 
    WHERE 
      g.id = #{ game_id } 
    RETURN 
      g
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_games
    |> Helpers.return_expected_single
  end


  def select_all_by_match( match_id ) do

    query = """
    MATCH 
      (m:Match)-[:Contains]->(g:Game)
    WHERE 
      m.id = #{ match_id } 
    RETURN 
      g
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_games
    |> Helpers.return_as_tuple
  end
  

  #Helpers
  defp nodes_to_games( nodes ) do
      Enum.map( nodes, &node_to_game/1 )
  end

  defp node_to_game( node ) do
    tags = extract_tags(node["g"])
    node["g"].properties
    |> Helpers.atomize_keys
    |> Map.put(:tags, tags)
  end

  defp extract_tags(%{labels: labels}) do
    Enum.filter(labels, fn(l)-> l == "TIER" || l == "ARENA" end)
  end
end
