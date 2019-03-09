defmodule MagiratorStore.Structs.Deck do
  
  defstruct(
    name:   "",
    theme:  "",
    format: "",
    black:  :false,
    white:  :false,
    red:  :false,
    green:  :false,
    blue:  :false,
    colorless:  :false,
  )

  def mapHasValidValues?(%{} = map) do
    :true
  end

  def mapHasValidValues?(_) do
    :false
  end
end