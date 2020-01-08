defmodule MagiratorStore.Stores.DeckStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Structs.Deck
  alias MagiratorStore.Helpers

  import MagiratorStore.Stores.IdStore

  def create( %Deck{} = deck, player_id ) do

    { :ok, generated_id } = next_id()

    query = """
      MATCH   
        (p:Player)  
      WHERE  
        p.id = #{ player_id } 
      CREATE  
      (p) 
        -[:Constructed]-> 
      (n:Deck:Active:PERSISTENT { id:#{ generated_id } } )  
        -[:Currently]-> 
      (d:Data {  
        created:TIMESTAMP(), 
        name: "#{ deck.name }",
        format: "#{ deck.format }", 
        theme: "#{ deck.theme }", 
        black: #{ deck.black }, 
        white: #{ deck.white }, 
        red: #{ deck.red }, 
        green: #{ deck.green }, 
        blue: #{ deck.blue }, 
        colorless: #{ deck.colorless }
      })  
      RETURN n.id as id;
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

  def create( _, _player_id ) do
    { :error, :only_struct }
  end


  def select_all_by_player( player_id ) do
    query = """
    MATCH 
      (p:Player)-[:Constructed]->(d:Deck)
      -[:Currently]->(data:Data) 
    WHERE 
      p.id = #{ player_id } 
    RETURN 
      d, data
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_decks
    |> Helpers.return_as_tuple
  end


  def select_by_id( deck_id ) do
    query = """
    MATCH 
      (d:Deck)-[:Currently]->(data:Data) 
    WHERE 
      d.id = #{ deck_id } 
    RETURN 
      d, data
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_decks
    |> Helpers.return_expected_single
  end


  def select_all() do
    query = """
    MATCH 
      (d:Deck)-[:Currently]->(data:Data) 
    RETURN 
      d, data
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_decks
    |> Helpers.return_as_tuple
  end

  def select_all(%{constructed_by: player_id}) when is_number player_id do
    
    query = """
    MATCH 
      (d:Deck)-[:Currently]->(data:Data),
      (d)<-[:Constructed]-(p:Player)
    WHERE
      p.id = #{player_id}
    RETURN 
      d, data
    """
    
    Bolt.query!(Bolt.conn, query)
    |> nodes_to_decks
    |> Helpers.return_as_tuple
  end


  def update_tier(deck_id, %{tier: tier, delta: delta}) when is_number (deck_id + tier + delta) do
    query = """
    MATCH 
      (d:Deck) 
    WHERE 
      d.id = #{deck_id}
    SET 
      d.tier = #{tier}
      ,d.delta = #{delta}
    """

    Bolt.query!(Bolt.conn, query)
    |> Helpers.update_evaluation(2)
  end


  #Helpers
  defp nodes_to_decks( nodes ) do
      Enum.map( nodes, &node_to_deck/1 )
  end

  defp node_to_deck( node ) do
    merged = Map.merge( node["d"].properties, node["data"].properties )
  
    if Deck.map_has_valid_values? merged do
      struct(Deck, Helpers.atomize_keys merged)
    else
      { :error, :invalid_data }
    end
  end
end