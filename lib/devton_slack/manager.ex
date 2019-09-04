defmodule DevtonSlack.Manager do
  use Application
  use GenServer

  import Logger
  alias Devton.Workspaces

  @delay 90_000

  def start(_, state) do
    {:ok, state}
  end

  def start_link do
    GenServer.start_link(__MODULE__, MapSet.new(), name: __MODULE__)
  end

  def init(state) do
    poll(100)
    {:ok, state}
  end

  def refresh do
    GenServer.cast(__MODULE__, :refresh_bots)
  end

  def handle_cast(:refresh_bots, state) do
    {:noreply, start_all_bots()}
  end

  def handle_info(:start_bots, state) do
    start_bots(state)
  end

  def atomize_workspace_name(workspace_name, channel \\ false) do
    suffix = if channel == true, do: "channel", else: ""
    :crypto.hash(:md5, workspace_name <> suffix)
    |> Base.encode16()
    |> String.to_atom()
  end

  defp start_bots(_state) do
    process_ids = start_all_bots()
    poll()
    {:noreply, process_ids}
  end

  defp poll(delay \\ @delay) do
    if Application.get_env(:devton, :env) != :test do
      Process.send_after(self(), :start_bots, delay)
    end
  end

  defp start_all_bots() do
    Workspaces.get_workspaces()
    |> Enum.filter(fn workspace -> workspace.enabled end)
    |> Enum.map(
         fn workspace ->
            Logger.info "elo"
           atomized_name = atomize_workspace_name(workspace.name)
           processes =
             if :erlang.whereis(atomized_name) == :undefined do
               Logger.info("Starting Slack bot for following workspace: #{workspace.name}")
               DevtonSlack.Supervisor.start_link(workspace)
             end
           processes
         end
       )
  end
end
