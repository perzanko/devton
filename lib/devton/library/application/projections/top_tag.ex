defmodule Devton.Library.Projections.TopTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "top_tag" do
    field :tag_name, :string

    timestamps([type: :utc_datetime])
  end

  def changeset(top_tag, params \\ %{}) do
    top_tag
    |> cast(
         params,
         [
           :tag_name
         ]
       )
  end
end
