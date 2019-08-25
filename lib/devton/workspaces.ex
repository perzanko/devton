defmodule Devton.Workspaces do
  @moduledoc false

  alias Devton.Repo
  alias Devton.Router

  alias Devton.Workspaces.Commands.{
    CreateWorkspace
    }

  alias Devton.Workspaces.Projections.Workspace

  def create_workspace(
        %{
          "name" => name,
          "token" => token,
          "enabled" => enabled,
        }
      ) do
    uuid = UUID.uuid4()

    dispatch_result =
      %CreateWorkspace{
        uuid: uuid,
        name: name,
        token: token,
        enabled?: enabled,
      }
      |> Router.dispatch()

    case dispatch_result do
      :ok ->
        {
          :ok,
          %Workspace{uuid: uuid}
        }
      reply ->
        reply
    end
  end

end
