defmodule Devton.Workspaces.Projectors.WorkspaceCreatedTest do
  use Devton.ProjectorCase

  alias Devton.Workspaces.Projections.Workspace
  alias Devton.Workspaces.Events.WorkspaceCreated
  alias Devton.Workspaces.Projectors.WorkspaceCreated, as: Projector

  test "should succeed with valid data" do
    uuid = UUID.uuid4()

    workspace_created_event = %WorkspaceCreated{
      uuid: uuid,
      name: "test_name",
      token: "test_token",
      enabled?: true
    }

    last_seen_event_number = get_last_seen_event_number("Workspaces.Projectors.WorkspaceCreated")

    assert :ok =
             Projector.handle(
               workspace_created_event,
               %{event_number: last_seen_event_number + 1}
             )

    assert only_instance_of(Workspace).name == "test_name"
    assert only_instance_of(Workspace).uuid == uuid
  end
end
