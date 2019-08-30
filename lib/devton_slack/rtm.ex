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
    try do
      command = Cli.handle_command(message.text)
      Logger.info("Message: '#{message.text}', Command: '#{inspect(command)}', channel '#{message.channel}'")
      case command do
        {:subscribe, %{tag: tag, time: time, day: day, }} ->
          indicate_typing(message.channel, slack)
          #       TODO: sub command dispatch
        {:unsubscribe, %{id: id}} ->
          indicate_typing(message.channel, slack)
          #       TODO: unsub command dispatch
        {:help} ->
          indicate_typing(message.channel, slack)
          send_message(Message.help, message.channel, slack)
        {:status} ->
          indicate_typing(message.channel, slack)
          send_message(Message.status, message.channel, slack)
        {:invalid_command} ->
          indicate_typing(message.channel, slack)
          send_message(Message.invalid_command, message.channel, slack)
      end
      {:ok, state}
    rescue
      _ -> {:ok, state}
    end
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    Logger.info "Sending message '#{text}' to channel '#{channel}'"
    send_message(text, channel, slack)
    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
