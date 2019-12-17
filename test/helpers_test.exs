defmodule HelpersTest do
  use ExUnit.Case

  alias MagiratorStore.Helpers

  test "update_evaluation success" do
    assert :ok = Helpers.update_evaluation(%{stats: %{"properties-set" => 2}, type: "w"}, 2)
  end

  test "update_evaluation error" do
    assert :error = Helpers.update_evaluation(%{stats: %{"properties-set" => 2}, type: "w"}, 3) #Wrong expected
    assert :error = Helpers.update_evaluation("Wrong format", 2)
  end
end