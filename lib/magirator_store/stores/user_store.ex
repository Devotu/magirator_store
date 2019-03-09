defmodule MagiratorStore.Stores.UserStore do
  
  alias Bolt.Sips, as: Bolt
  alias MagiratorStore.Helpers
  alias MagiratorStore.Structs.User
  import MagiratorStore.Stores.IdStore
  
  def create( name, password ) do
    
    { :ok, generated_id } = next_id()

    query = """
      CREATE 
        (u:User:Active:PERSISTENT { id:#{ generated_id } }) 
        -[:Currently]-> 
        (d:Data { created:TIMESTAMP(), name:"#{ name }", password:"#{ password }" })
      RETURN 
        u.id as id;
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


  def select_by_name(name) do

    query = """
    MATCH 
      (u:User)-[:Currently]->(data:Data) 
    WHERE 
      data.name = "#{name}" 
    RETURN 
      u,data
    """

    Bolt.query!(Bolt.conn, query)
    |> nodes_to_users
    |> Helpers.return_expected_single
  end

    #Helpers
  defp nodes_to_users( nodes ) do
      Enum.map( nodes, &node_to_user/1 )
  end

  defp node_to_user( node ) do
    user_map =
    Map.merge( node["u"].properties, node["data"].properties )
    |> Helpers.atomize_keys

    struct(User, user_map)
  end
end
