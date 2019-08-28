defmodule DevtonSlack.Rtm do
  use Slack
  require Logger

  alias DevtonSlack.{Cli, Message}

  def send_message_to_channel(workspace_name, channel, message) do
    pid = Process.whereis(String.to_atom(workspace_name <> "_channel"))
    send pid, {:message, message, channel}
  end

  def handle_connect(slack, state) do
    Logger.info("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    Logger.info("Got message '#{message.text}' from user '#{message.user}'")

    cli_parser_result = Cli.parse_command(message.text)
    case cli_parser_result do
      {:ok, [:subscribe, cron, tags]} ->
#       TODO: sub command dispatch
        indicate_typing(message.channel, slack)
      {:ok, [:unsubscribe] } ->
#       TODO: unsub command dispatch
        indicate_typing(message.channel, slack)
      {:ok, [:help] } ->
        send_message(Message.help, message.channel, slack)
      {:error, :missing_parameters } ->
        send_message(Message.missing_parameters, message.channel, slack)
      {:error, _} ->
        send_message(Message.invalid_command, message.channel, slack)
    end
#
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    Logger.info "Sending message '#{text}' to channel '#{channel}'"
    send_message(text, channel, slack)
    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
