defmodule Devton.Library.Projectors.TagCreated do
  use Commanded.Projections.Ecto, name: "Library.Projectors.TagCreated"

  alias Devton.Repo
  alias Devton.Library.Events.TagCreated
  alias Devton.Library.Projections.Tag

  project(
    %TagCreated{} = event,
    _metadata,
    fn multi ->
      changeset = Tag.changeset(%Tag{}, %{
        id: event.id,
        name: event.name,
        bg_color_hex: event.bg_color_hex,
        text_color_hex: event.text_color_hex
      })
      Ecto.Multi.insert_or_update(
        multi,
        :tag,
        changeset
      )
    end
  )
end
