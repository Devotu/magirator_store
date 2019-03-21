defmodule MagiratorStore.Stores.MatchStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Helpers

  import MagiratorStore.Stores.IdStore

  def create( match ) do
    
    { :ok, generated_id } = next_id()

    [player_one_id, player_two_id] = match.players

    query = """
      MATCH 
        (pc:Player),
        (p1:Player),
        (p2:Player)
      WHERE 
        pc.id = #{ match.creator_id } AND 
        p1.id = #{ player_one_id } AND
        p2.id = #{ player_two_id } 
      CREATE 
        (pc)-[:Created]->(m:Match { id:#{ generated_id }, created:TIMESTAMP() }),
        (p1)-[:Participated { player: 1} ]->(m)<-[:Participated { player: 2} ]-(p2)
      RETURN 
        m.id as id;
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


  def add_game( game_id, match_id ) do

    query = """
      MATCH 
        (m:Match) 
        , (g:Game)
      WHERE 
        m.id = #{ match_id } 
        AND g.id = #{ game_id } 
      CREATE
        (m)-[:Contains]->(g) 
      RETURN 
        m.id as id;
    """
    
    result = Bolt.query!(Bolt.conn, query)
    [ row ] = result
    { updated_id } = { row["id"] }

    case updated_id == match_id do
      :true ->
        { :ok }
      :false ->
        { :error, {match_id, updated_id} }
        # { :error, :insert_failure }
    end
  end


  def select_by_id( match_id ) do

    query = """
    MATCH 
      (m:Match)  
    WHERE 
      m.id = #{ match_id } 
    RETURN 
      m
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_matches
    |> Helpers.return_expected_single
  end


  #Helpers
  defp nodes_to_matches( nodes ) do
      Enum.map( nodes, &node_to_match/1 )
  end

  defp node_to_match( node ) do
    node["m"].properties
    |> Helpers.atomize_keys
  end
end