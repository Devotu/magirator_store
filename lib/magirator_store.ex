defmodule MagiratorStore do
  alias MagiratorStore.Stores.UserStore
  alias MagiratorStore.Stores.PlayerStore
  alias MagiratorStore.Stores.DeckStore
  alias MagiratorStore.Stores.GameStore
  alias MagiratorStore.Stores.ResultStore

  defdelegate create_user(name, password), to: UserStore, as: :create
  defdelegate get_by_name(user_name), to: UserStore, as: :select_by_name

  defdelegate create_player(name, user_is), to: PlayerStore, as: :create
  defdelegate list_players(), to: PlayerStore, as: :select_all
  defdelegate get_player(player_id), to: PlayerStore, as: :select_by_id
  
  defdelegate create_deck(deck, player_id), to: DeckStore, as: :create
  defdelegate list_decks(), to: DeckStore, as: :select_all
  defdelegate get_deck(deck_id), to: DeckStore, as: :select_by_id
  
  defdelegate create_game(game), to: GameStore, as: :create

  defdelegate add_result(result), to: ResultStore, as: :add
  defdelegate list_results_by_deck(deck_id), to: ResultStore, as: :select_all_by_deck
end
