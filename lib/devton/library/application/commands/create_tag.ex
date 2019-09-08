defmodule Devton.Library.Commands.CreateTag do
  @enforce_keys [:id, :name]
  defstruct [:id, :name, :bg_color_hex, :text_color_hex]
end
