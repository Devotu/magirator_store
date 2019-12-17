defmodule NeoHelperTest do
  use ExUnit.Case
  
  alias MagiratorStore.NeoHelper

  test "neo-tags" do
    assert [":TIER"] == NeoHelper.as_labels [:tier]
  end

  test "neo-tag-line" do
    assert ":TIER:ARENA" == NeoHelper.as_label_line [:tier, :arena]
  end
end