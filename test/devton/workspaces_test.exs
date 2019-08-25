defmodule Devton.Workspaces.WorkspacesTest do
  use Devton.Test.InMemoryEventStoreCase
  use Devton.ProjectorCase

  alias Devton.Workspaces
  alias Devton.Workspaces.Projections.Workspace

  test "opens account with valid command" do
    params = %{
      "name" => "test_name",
      "token" => "test_token",
      "enabled" => true,
    }

    assert {:ok, %Workspace{ uuid: uuid } } = Workspaces.create_workspace(params)
    assert is_binary(uuid) == true
  end

end
