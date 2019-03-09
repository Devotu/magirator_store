defmodule MagiratorStore.Stores.IdStore do

    alias Bolt.Sips, as: Bolt
    
    def next_id() do
        
        query = """
        MERGE (id:GlobalUniqueId)
        ON CREATE SET id.count = 1  
        ON MATCH SET id.count = id.count + 1 
        RETURN id.count AS generated_id 
        """
        
        result = Bolt.query!(Bolt.conn, query)
        [ row ] = result
        [{ id }] = [ { row["generated_id"] } ]
        { :ok, id }
    end
end