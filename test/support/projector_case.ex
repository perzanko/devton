defmodule Devton.ProjectorCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Devton.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Devton.DataCase

      import Devton.Test.ProjectorUtils
    end
  end

  setup _tags do
    :ok = Devton.Test.ProjectorUtils.truncate_database
    :ok
  end
end
