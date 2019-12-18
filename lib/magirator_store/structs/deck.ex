defmodule MagiratorStore.Structs.Deck do
  
  defstruct(
    id: 0,
    name:   "",
    theme:  "",
    format: "",
    black:  :false,
    white:  :false,
    red:  :false,
    green:  :false,
    blue:  :false,
    colorless:  :false,
    tier: 0, 
    delta: 0
  )

  def map_has_valid_values?(%{} = _map) do
    :true
  end

  def map_has_valid_values?(_) do
    :false
  end
end