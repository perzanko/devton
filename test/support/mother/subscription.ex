defmodule Devton.Test.Mother.Subscription do
  @moduledoc false

  def simple() do
    %{
      "tags" => "javascript,elixir",
      "day" => "monday",
      "time" => "10:00",
      "workspace_id" => "workspace_id",
      "workspace_name" => "workspace_name",
      "user_id" => "user_id",
      "user_name" => "user_name",
      "user_tz" => "Europe/Warsaw",
    }
  end

  def with_invalid_day() do
    %{
      simple() |
      "day" => "freeday"
    }
  end

  def with_invalid_time() do
    %{
      simple() |
      "time" => "10:00,x"
    }
  end
end
