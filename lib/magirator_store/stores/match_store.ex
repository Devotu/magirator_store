defmodule MagiratorStore.Stores.MatchStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Helpers
  alias MagiratorStore.NeoHelper
  alias MagiratorStore.Structs.Match

  import MagiratorStore.Stores.IdStore

  def create( match ) do
    { :ok, generated_id } = next_id()
    tags = NeoHelper.as_label_line(match.tags)

    query = """
      MATCH 
        (pc:Player)
      WHERE 
        pc.id = #{ match.creator_id }
      CREATE 
        (pc)-[:Created]->(m:Match#{tags} { id:#{ generated_id }, created:TIMESTAMP() })
      RETURN 
        m.id as id;
    """
    
    Bolt.query!(Bolt.conn, query)
    |> Helpers.return_result_id
    |> Helpers.return_expected_matching_id( generated_id )
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


  def delete( match_id ) do

    query = """
    MATCH 
      (m:Match),
      (m)-[:Contains]->(g:Game)<-[:In]-(r:Result),
      (m)<-[:In]-(p:Participant)
    WHERE 
      m.id = #{ match_id } 
    DETACH DELETE m,g,r,p
    """

    result = Bolt.query!(Bolt.conn, query)

    case result["nodes-deleted"] do
      n when n > 0 ->
        {:ok}
      _ ->
        {:error, "no nodes deleted"}        
    end
  end


  #Helpers
  defp nodes_to_matches( nodes ) do
      Enum.map( nodes, &node_to_match/1 )
  end

  defp node_to_match( node ) do
    tags = %{tags: NeoHelper.extract_tags(node["m"])}

    match = node["m"].properties
    |> Helpers.atomize_keys

    struct(Match, Map.merge(match, tags))
  end
end