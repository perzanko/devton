defmodule Devton.Library.Events.TagCreated do
  @derive [Jason.Encoder]
  defstruct [:id, :name, :bg_color_hex, :text_color_hex]
end
