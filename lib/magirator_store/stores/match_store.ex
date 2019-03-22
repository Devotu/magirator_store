defmodule MagiratorStore.Stores.MatchStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Helpers

  import MagiratorStore.Stores.IdStore

  def create( match ) do
    
    { :ok, generated_id } = next_id()

    [participant_one, participant_two] = match.participants

    query = """
      MATCH 
        (pc:Player),
        (p1:Player),
        (d1:Deck),
        (p2:Player),
        (d2:Deck)
      WHERE 
        pc.id = #{ match.creator_id } AND 
        p1.id = #{ participant_one.player_id } AND
        d1.id = #{ participant_one.deck_id } AND
        p2.id = #{ participant_two.player_id } AND
        d2.id = #{ participant_two.deck_id }
      CREATE 
        (pc)-[:Created]->(m:Match { id:#{ generated_id }, created:TIMESTAMP() }),
        (p1)-[:Was]->(pt1:Participant { number: 1 })-[:In]->(m), (pt1)-[:Used]->(d1),
        (p2)-[:Was]->(pt2:Participant { number: 2 })-[:In]->(m), (pt2)-[:Used]->(d2)
      RETURN 
        m.id as id;
    """

    IO.puts(query)
    
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