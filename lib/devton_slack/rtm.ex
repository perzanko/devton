defmodule DevtonSlack.Rtm do
  use Slack
  require Logger

  def send_message_to_channel(workspace_name, channel, message) do
    pid = Process.whereis(String.to_atom(workspace_name <> "_channel"))
    send pid, {:message, message, channel}
  end

  def handle_connect(slack, state) do
    Logger.info("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    Logger.info "Got message '#{message.text}'"
#    send_message("I got a message!", message.channel, slack)
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    Logger.info "Sending your message, captain! '#{text}'"
    send_message(text, channel, slack)
    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
