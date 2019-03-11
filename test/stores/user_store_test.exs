defmodule UserStoreTest do
  use ExUnit.Case
  
  import MagiratorStore.Stores.UserStore

  test "get user" do
    {:ok, user} = select_by_name("Adam")
    assert "Adam" == user.name
    assert 1 == user.id
  end
end