defmodule MagiratorStore.Stores.PlayerStore do
    
  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Helpers
  alias MagiratorStore.Structs.Player
  import MagiratorStore.Stores.IdStore
  
  def create( name, user_id ) do
    
    { :ok, generated_id } = next_id()

    query = """
      MATCH 
        (u:User) 
      WHERE 
        u.id = #{ user_id } 
      CREATE 
        (u)
        -[:Is]->
        (p:Player:Active:PERSISTENT { id:#{ generated_id } }) 
        -[:Currently]-> 
        (d:Data { created:TIMESTAMP(), name:"#{ name }" })
      RETURN 
        p.id as id;
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


  def select_all() do

    query = """
    MATCH
      (p:Player)-[:Currently]->(data:Data) 
    RETURN 
      p,data
    """

    players = 
      Bolt.query!(Bolt.conn, query)
      |> nodes_to_players

    {:ok, players}
  end


  def select_by_id( player_id ) do

    query = """
    MATCH 
      (p:Player)-[:Currently]->(data:Data) 
    WHERE 
      p.id = #{ player_id } 
    RETURN 
      p, data
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_players
    |> Helpers.return_expected_single
  end


  def select_by_deck( deck_id ) do

    query = """
    MATCH 
      (p:Player)-[:Currently]->(data:Data),
      (p)-[:Constructed]->(d:Deck)
    WHERE 
      d.id = #{ deck_id } 
    RETURN 
      p, data
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_players
    |> Helpers.return_expected_single
  end


  #Helpers
  defp nodes_to_players( nodes ) do
      Enum.map( nodes, &node_to_player/1 )
  end

  defp node_to_player( node ) do
    player_map =
    Map.merge( node["p"].properties, node["data"].properties )
    |> Helpers.atomize_keys

    struct(Player, player_map)
  end
end