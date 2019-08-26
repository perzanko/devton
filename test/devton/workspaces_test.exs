defmodule Devton.Workspaces.WorkspacesTest do
  use Devton.Test.InMemoryEventStoreCase
  use Devton.ProjectorCase

  alias Devton.Test.Mother
  alias Devton.Workspaces
  alias Devton.Workspaces.Projections.Workspace

  @tag :create_workspace
  test "creates workspace with valid command" do
    workspace = Mother.Workspace.simple()
    assert {:ok, %Workspace{ uuid: uuid } } = Workspaces.create_workspace(workspace)
    assert is_binary(uuid) == true
  end

  @tag :create_workspace_invalid
  test "creates workspace with invalid command" do
    params = Mother.Workspace.without_token()
    assert { :error, _, _, _ } = Workspaces.create_workspace(params)
  end

  @tag :enable_workspace
  test "enables workspace with valid command" do
    workspace = Mother.Workspace.simple()
    {:ok, %Workspace{ uuid: uuid } } = Workspaces.create_workspace(workspace)
    assert { :ok, true } = Workspaces.enable_workspace(%{"id" => uuid})
  end


  @tag :disable_workspace
  test "disables workspace with valid command" do
    workspace = Mother.Workspace.simple()
    {:ok, %Workspace{ uuid: uuid } } = Workspaces.create_workspace(workspace)
    assert { :ok, true } = Workspaces.disable_workspace(%{"id" => uuid})
  end
end
