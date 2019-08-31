defmodule Devton.Library do
  @moduledoc false

  alias Devton.Repo
  alias Devton.Router

  alias Devton.Library.Commands.{
    CreateTag,
    }

  alias Devton.Library.Projections.Tag

  def create_tag(tag, metadata \\ %{}) do
    result =
      %CreateTag{
        id: tag["id"],
        name: tag["name"],
        bg_color_hex: tag["bg_color_hex"],
        text_color_hex: tag["text_color_hex"],
      }
      |> Router.dispatch(metadata: metadata)

    case result do
      :ok ->
        {
          :ok,
          %Tag{id: tag["id"]}
        }
      reply ->
        reply
    end
  end

end
