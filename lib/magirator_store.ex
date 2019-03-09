defmodule MagiratorStore do
  alias MagiratorStore.Stores.UserStore
  alias MagiratorStore.Stores.PlayerStore
  alias MagiratorStore.Stores.DeckStore
  alias MagiratorStore.Stores.GameStore
  alias MagiratorStore.Stores.ResultStore

  defdelegate create_user(name, password), to: UserStore, as: :create

  defdelegate create_player(name, user_is), to: PlayerStore, as: :create
  defdelegate list_players(), to: PlayerStore, as: :select_all
  
  defdelegate create_deck(deck, player_id), to: DeckStore, as: :create
  defdelegate list_decks(), to: DeckStore, as: :select_all
  defdelegate get_deck(deck_id), to: DeckStore, as: :select_by_id
  
  defdelegate create_game(game), to: GameStore, as: :create

  defdelegate add_result(result), to: ResultStore, as: :add
end
