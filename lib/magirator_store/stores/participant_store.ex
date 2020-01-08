defmodule MagiratorStore.Stores.ParticipantStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Structs.Participant
  alias MagiratorStore.Helpers

  import MagiratorStore.Stores.IdStore

  def create( %Participant{} = participant, match_id ) do

    { :ok, generated_id } = next_id()

    query = """
      MATCH   
        (m:Match),
        (p:Player),
        (d:Deck)
      WHERE  
        m.id = #{ match_id } AND 
        p.id = #{ participant.player_id } AND
        d.id = #{ participant.deck_id }
      CREATE  
        (p)
        -[:Was]->
        (pt:Participant { id:#{ generated_id }, number: #{ participant.number } })
        -[:In]->
        (m), 
        (pt)-[:Used]->(d)
      RETURN pt.id as id;
    """
    
    %{results: result} = Bolt.query!(Bolt.conn, query)
    [ row ] = result
    { created_id } = { row["id"] }

    Helpers.return_expected_matching_id( created_id, generated_id )
  end

  def create( _, _match_id ) do
    { :error, :only_struct }
  end


  def select_all_by_match( match_id ) do

    query = """
    MATCH 
      (p:Player)
      -[:Was]->
      (pt:Participant)
      -[:In]->
      (m:Match),
      (pt)
      -[:Used]->
      (d:Deck)
    WHERE 
      m.id = #{ match_id } 
    RETURN 
      pt, 
      p.id AS player_id, 
      d.id AS deck_id,
      m.id AS match_id
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_participants
    |> Helpers.return_as_tuple
  end


  #Helpers
  defp nodes_to_participants( nodes ) do
      Enum.map( nodes, &node_to_participant/1 )
  end

  defp node_to_participant( node ) do
    result = node["pt"].properties
    player_id = node["player_id"]
    deck_id = node["deck_id"]
    match_id = node["match_id"]

    Map.merge( %{"player_id" => player_id, "deck_id" => deck_id, "match_id" => match_id}, result )
    |> Helpers.atomize_keys
  end

end