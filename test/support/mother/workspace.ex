defmodule Devton.Test.Mother.Workspace do
  @moduledoc false

  def simple() do
    %{
      "name" => "test_name",
      "identifier" => "test_id",
      "token" => "test_token",
      "enabled" => true,
    }
  end

  def without_token() do
    %{
      "name" => "test_name",
      "identifier" => "test_id",
      "token" => nil,
      "enabled" => false,
    }
  end
end
