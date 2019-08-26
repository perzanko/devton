defmodule Devton.Workspaces do
  @moduledoc false

  alias Devton.Repo
  alias Devton.Router

  alias Devton.Workspaces.Commands.{
    CreateWorkspace,
    EnableWorkspace,
    DisableWorkspace,
    }

  alias Devton.Workspaces.Projections.Workspace

  def get_workspace(clause) do
    result = case clause do
      %{ "id" => uuid } ->
        Repo.get(Workspace, uuid)
      %{ "name" => name } ->
        Repo.get_by(Workspace, name: name)
      _ -> {:error, :invalid_query}
    end
    case result do
      %Workspace{} = workspace ->
        {:ok, workspace}
      _ ->
        {:error, :not_found}
    end
  end

  def get_workspaces() do
    Repo.all(Workspace)
  end

  def create_workspace(
        %{
          "name" => name,
          "token" => token,
          "enabled" => enabled,
        }
      ) do
    uuid = UUID.uuid4()

    result =
      %CreateWorkspace{
        uuid: uuid,
        name: name,
        token: token,
        enabled?: enabled,
      }
      |> Router.dispatch()

    case result do
      :ok ->
        {
          :ok,
          %Workspace{uuid: uuid}
        }
      reply ->
        reply
    end
  end

  def enable_workspace(%{"id" => uuid}) do
    result =
      %EnableWorkspace{uuid: uuid}
      |> Router.dispatch()
    case result do
      :ok -> {:ok, true}
      reply -> reply
    end
  end

  def disable_workspace(%{"id" => uuid}) do
    result =
      %DisableWorkspace{uuid: uuid}
      |> Router.dispatch()
    case result do
      :ok -> {:ok, true}
      reply -> reply
    end
  end

end
