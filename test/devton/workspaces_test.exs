defmodule Devton.Workspaces.WorkspacesTest do
  use Devton.Test.InMemoryEventStoreCase
  use Devton.ProjectorCase

  alias Devton.Test.Mother
  alias Devton.Workspaces
  alias Devton.Workspaces.Projections.Workspace

  @tag :create_workspace
  test "creates workspace with valid command" do
    workspace = Mother.Workspace.simple()
    assert {:ok, %Workspace{uuid: uuid}} = Workspaces.create_workspace(workspace)
    assert is_binary(uuid) == true
  end

  @tag :create_workspace
  test "creates workspace with invalid command" do
    params = Mother.Workspace.without_token()
    assert {:error, _, _, _} = Workspaces.create_workspace(params)
  end

  @tag :enable_workspace
  test "enables workspace with valid command" do
    workspace = Mother.Workspace.simple()
    {:ok, %Workspace{uuid: uuid}} = Workspaces.create_workspace(workspace)
    assert {:ok, true} = Workspaces.enable_workspace(%{"id" => uuid, "token" => "test_token", "bot_token" => "test_bot_token"})
  end

  @tag :disable_workspace
  test "disables workspace with valid command" do
    workspace = Mother.Workspace.simple()
    {:ok, %Workspace{uuid: uuid}} = Workspaces.create_workspace(workspace)
    assert {:ok, true} = Workspaces.disable_workspace(%{"id" => uuid})
  end

  @tag :get_workspace
  test "gets workspace by id" do
    workspace = Mother.Workspace.simple()
    {:ok, %Workspace{uuid: uuid}} = Workspaces.create_workspace(workspace)
    :timer.sleep(500)
    assert {:ok, %Workspace{uuid: uuid, name: name}} = Workspaces.get_workspace(%{"id" => uuid})
    assert name = Map.get(workspace, "name")
  end

  @tag :get_workspace
  test "gets workspace by name" do
    workspace = Mother.Workspace.simple()
    {:ok, %Workspace{}} = Workspaces.create_workspace(workspace)
    :timer.sleep(500)
    assert {:ok, %Workspace{uuid: uuid, name: name}} = Workspaces.get_workspace(%{"name" => Map.get(workspace, "name")})
  end

  @tag :get_workspace
  test "gets workspace with empty query" do
    assert {:error, :not_found} = Workspaces.get_workspace(%{})
  end

  @tag :get_workspaces
  test "gets workspaces" do
    workspace = Mother.Workspace.simple()
    Workspaces.create_workspace(workspace)
    Workspaces.create_workspace(workspace)
    :timer.sleep(500)
    result = Workspaces.get_workspaces()
    assert length(result) == 2
  end
end
