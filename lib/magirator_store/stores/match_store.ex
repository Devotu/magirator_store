defmodule MagiratorStore.Stores.MatchStore do

  alias Bolt.Sips, as: Bolt

  import MagiratorStore.Stores.IdStore

  def create( match ) do
    
    { :ok, generated_id } = next_id()

    query = """
      MATCH 
        (p:Player) 
      WHERE 
        p.id = #{ match.creator_id } 
      CREATE 
        (p)-[:Created]->(g:Match { id:#{ generated_id }, created:TIMESTAMP() })
      RETURN 
        g.id as id;
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
        { :error, :insert_failure }
    end
  end
end