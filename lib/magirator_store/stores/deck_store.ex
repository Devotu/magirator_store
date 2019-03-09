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
        -[:Created]-> 
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

  def create( _, player_id ) do
    { :error, :only_struct }
  end


  def select_all_by_player( player_id ) do

    query = """
    MATCH 
      (p:Player)-[:Created]->(d:Deck)
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


  #Helpers
  defp nodes_to_decks( nodes ) do
      Enum.map( nodes, &node_to_deck/1 )
  end

  defp node_to_deck( node ) do
    merged = Map.merge( node["d"].properties, node["data"].properties )
  
    if Deck.mapHasValidValues? merged do
      Helpers.atomize_keys merged
    else
      { :error, :invalid_data }
    end
  end

end