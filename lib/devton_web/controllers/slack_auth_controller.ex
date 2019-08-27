defmodule DevtonWeb.SlackAuthController do
  use DevtonWeb, :controller

  alias Devton.Workspaces
  alias Devton.Workspaces.Projections.Workspace

  action_fallback FallbackController

  def index(conn, %{"code" => code, "state" => state}) do
    with %{"ok" => true} = workspace_details <- authorize(code) do
      existing_workspace = Workspaces.get_workspace(%{"name" => workspace_details["team_name"]})
      case existing_workspace do
        {:ok, %Workspace{uuid: uuid}} ->
          Workspaces.enable_workspace(%{
            "id" => uuid,
            "token" => workspace_details["bot"]["bot_access_token"],
          })
        _ ->
          Workspaces.create_workspace(
            %{
              "name" => workspace_details["team_name"],
              "token" => workspace_details["bot"]["bot_access_token"],
              "identifier" => workspace_details["team_id"],
              "enabled" => true,
            }
          )
      end

      redirect(conn, external: "https://#{workspace_details["team_name"]}.slack.com/")
    end
  end

  defp authorize(code) do
    Slack.Web.Oauth.access(
      Application.get_env(:slack, :client_id),
      Application.get_env(:slack, :client_secret),
      code,
      %{redirect_uri: Application.get_env(:slack, :root_url)}
    )
  end
end


