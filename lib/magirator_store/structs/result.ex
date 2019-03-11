defmodule MagiratorStore.Structs.Result do
  
  defstruct(
    id: 0, 
    player_id: 0, 
    deck_id: 0, 
    game_id: 0, 
    place: 0, 
    comment: ""
  ) 

  def map_has_valid_values?(%{} = map) do
    :true
  end

  def map_has_valid_values?(_) do
    :false
  end
end