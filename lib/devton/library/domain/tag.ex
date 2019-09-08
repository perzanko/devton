defmodule Devton.Library.Aggregates.Tag do
  defstruct id: nil,
            name: nil,
            bg_color_hex: nil,
            text_color_hex: nil

  alias __MODULE__

  alias Devton.Library.Commands.{
    CreateTag,
    }
  alias Devton.Library.Events.{
    TagCreated
    }

  def execute(
        %Tag{},
        %CreateTag{
          id: id,
          name: name,
          bg_color_hex: bg_color_hex,
          text_color_hex: text_color_hex,
        }
      ) do
    %TagCreated{
      id: id,
      name: name,
      bg_color_hex: bg_color_hex,
      text_color_hex: text_color_hex,
    }
  end

  #  state mutators

  def apply(
        %Tag{},
        %TagCreated{
          id: id,
          name: name,
          bg_color_hex: bg_color_hex,
          text_color_hex: text_color_hex,
        }
      ) do
    %Tag{
      id: id,
      name: name,
      bg_color_hex: bg_color_hex,
      text_color_hex: text_color_hex,
    }
  end
end
