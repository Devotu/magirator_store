defmodule MagiratorStore do
  alias MagiratorStore.Stores.UserStore
  alias MagiratorStore.Stores.PlayerStore
  alias MagiratorStore.Stores.DeckStore
  alias MagiratorStore.Stores.GameStore
  alias MagiratorStore.Stores.ResultStore
  alias MagiratorStore.Stores.MatchStore
  alias MagiratorStore.Stores.ParticipantStore
  alias MagiratorStore.Stores.FrameStore

  defdelegate create_user(name, password), to: UserStore, as: :create
  defdelegate get_by_name(user_name), to: UserStore, as: :select_by_name

  defdelegate create_player(name, user_is), to: PlayerStore, as: :create
  defdelegate list_players(), to: PlayerStore, as: :select_all
  defdelegate get_player(player_id), to: PlayerStore, as: :select_by_id
  
  defdelegate create_deck(deck, player_id), to: DeckStore, as: :create
  defdelegate list_decks(), to: DeckStore, as: :select_all
  defdelegate get_deck(deck_id), to: DeckStore, as: :select_by_id
  
  defdelegate create_game(game), to: GameStore, as: :create
  defdelegate get_games_in_match(match_id), to: GameStore, as: :select_all_by_match

  defdelegate add_result(result), to: ResultStore, as: :add
  defdelegate list_results(), to: ResultStore, as: :select_all
  defdelegate list_results_by_deck(deck_id), to: ResultStore, as: :select_all_by_deck
  defdelegate list_results_by_game(game_id), to: ResultStore, as: :select_all_by_game

  defdelegate create_match(match), to: MatchStore, as: :create
  defdelegate get_match(match_id), to: MatchStore, as: :select_by_id
  defdelegate add_game_to_match(game_id, match_id), to: MatchStore, as: :add_game
  defdelegate delete_match(match_id), to: MatchStore, as: :delete

  defdelegate create_participant(participant, match_id), to: ParticipantStore, as: :create 
  defdelegate list_participants_by_match(match_id), to: ParticipantStore, as: :select_all_by_match
end
