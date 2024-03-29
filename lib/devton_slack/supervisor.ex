defmodule DevtonSlack.Supervisor do
  import Logger
  use GenServer

  alias Devton.Workspaces
  alias DevtonSlack.Manager

  def child_spec(workspace) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [workspace]},
      type: :supervisor
    }
  end

  # initializes the Genserver and init() is invoked after this
  def start_link(workspace) do
    GenServer.start_link(__MODULE__, workspace, name: Manager.atomize_workspace_name(workspace.name))
  end

  # start Slack Bot using `start_link` and monitor its errors
  def init(workspace) do
    Slack.Bot.start_link(
      DevtonSlack.Rtm,
      workspace,
      workspace.bot_token,
      %{name: Manager.atomize_workspace_name(workspace.name, true)}
    )
    |> handle_errors(workspace)
  end

  defp handle_errors({:ok, _} = response, workspace) do
    response
  end

  defp handle_errors({:error, "Slack API returned an error `invalid_auth" <> _ = message}, workspace),
       do: reset(workspace, message)

  defp handle_errors(
         {:error, "Slack API returned an error `account_inactive" <> _ = message},
         workspace
       ),
       do: reset(workspace, message)

  defp handle_errors(response, workspace) do
    Logger.warn("Unexpected response from start_link for #{workspace.name} - #{inspect(response)}")
  end

  defp reset(workspace, message) do
    Logger.warn("Starting workspace #{workspace.name} failed: #{message}")
    Workspaces.disable_workspace(%{"uuid" => workspace.uuid})
    :ignore
  end
end
