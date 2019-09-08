defmodule Devton.Library.Repositories.TagRepository do

  import Ecto.Query, only: [from: 2]
  import Ecto.Query

  alias Devton.Repo
  alias Devton.Library.Projections.Tag


  def find_all() do
    query = from t in Tag, select: t.name
    Repo.all query
  end
end
