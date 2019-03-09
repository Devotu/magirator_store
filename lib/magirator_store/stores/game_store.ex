defmodule MagiratorStore.Stores.GameStore do

  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Deck

  import MagiratorStore.Stores.IdStore
  import Ecto.Changeset

  def create( game ) do
    
    { :ok, generated_id } = next_id()

    query = """
      MATCH 
        (p:Player) 
      WHERE 
        p.id = #{ game.creator_id } 
      CREATE 
        (p)-[:Created]->(g:Game { id:#{ generated_id }, created:TIMESTAMP(), conclusion: "#{ game.conclusion }" })
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

end
