defmodule MagiratorStore.Stores.FrameStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Helpers


  def select_all_game_by_deck( deck_id ) do

      # Optional
      # (m:Match)
      # -[:Contains]->

    query = """
    MATCH 
      (p1:Player)-[:Got]->(r1:Result)-[:In]->(g:Game),
      (r1)-[:With]->(d1:Deck),
      (p2:Player)-[:Got]->(r2:Result)-[:In]->(g),
      (r2)-[:With]->(d2:Deck)
    WHERE 
      d1.id = #{ deck_id } 
    RETURN 
      g.id as game_id, 
      p1.id as player_one_id, r1.id as player_one_result_id, d1.id as player_one_deck_id, 
      p2.id as player_two_id, r2.id as player_two_result_id, d2.id as player_two_deck_id
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_game_frames
    |> Helpers.return_as_tuple
  end
  

  #Helpers
  defp nodes_to_game_frames( nodes ) do
      Enum.map( nodes, &nodes_to_game_frame/1 )
  end

  defp nodes_to_game_frame( node ) do
    IO.puts(Kernel.inspect(node))
    node
    |> Helpers.atomize_keys
  end
end