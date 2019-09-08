defmodule Devton.Library.Projections.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tag" do
    field :name, :string
    field :bg_color_hex, :string
    field :text_color_hex, :string

    timestamps([type: :utc_datetime])
  end

  def changeset(tag, params \\ %{}) do
    tag |> cast(params, [:name, :bg_color_hex, :text_color_hex])
  end
end
