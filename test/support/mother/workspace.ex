defmodule Devton.Test.Mother.Workspace do
  @moduledoc false

  def simple() do
    %{
      "name" => "test_name",
      "identifier" => "test_id",
      "token" => "test_token",
      "bot_token" => "test_bot_token",
      "enabled" => true,
    }
  end

  def without_token() do
    %{
      "name" => "test_name",
      "identifier" => "test_id",
      "token" => nil,
      "bot_token" => "test_bot_token",
      "enabled" => false,
    }
  end
end
