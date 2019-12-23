defmodule NeoHelperTest do
  use ExUnit.Case
  
  alias MagiratorStore.NeoHelper

  test "neo-tags" do
    assert [":TIER"] == NeoHelper.as_labels [:tier]
  end

  test "neo-tag-line" do
    assert ":TIER:ARENA" == NeoHelper.as_label_line [:tier, :arena]
  end

  test "extract tags" do
    match_node = %Bolt.Sips.Types.Node{
        id: 19,
        labels: ["Match", "TIER"],
        properties: %{"created" => 1577135022350, "id" => 50}
      }

    assert [:tier] == NeoHelper.extract_tags(match_node)
  end
end