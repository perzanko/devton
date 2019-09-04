defmodule DevtonSlack.Rtm do
  use Slack
  require Logger

  alias DevtonSlack.{Cli, Message, Manager}

  def send_message_to_channel(workspace_name, channel, message) do
    atomized_workspace_name = Manager.atomize_workspace_name(workspace_name, true);
    pid = Process.whereis(atomized_workspace_name)
    send pid, {:message, message, channel}
  end

  def handle_connect(slack, state) do
    Logger.info("Connected with workspace '#{slack.team.name}' (#{inspect slack.process})")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state)
      when String.contains?(message.text, "Do Not Disturb"), do:
        {:ok, state}
  def handle_event(message = %{type: "message"}, slack, state) do
    try do
      command = Cli.handle_command(message.text)
      Logger.info("Message: '#{message.text}', Command: '#{inspect(command)}', channel '#{message.channel}'")
      case command do
        {:subscribe, %{tag: tag, time: time, day: day}} ->
          result = Devton.Subscriptions.create_subscription(
            %{
              "tags" => tag,
              "time" => time,
              "day" => day,
              "user_name" => slack.users[message.user].name,
              "user_id" => message.user,
              "user_tz" => slack.users[message.user].tz,
              "workspace_id" => slack.team.id,
              "workspace_name" => slack.team.name,
            }
          )
          case result do
            {:error, :invalid_day} ->
              send_message(Message.invalid_day, message.channel, slack)
            {:error, :invalid_time} ->
              send_message(Message.invalid_time, message.channel, slack)
            {:error, _} ->
              send_message(Message.invalid_command, message.channel, slack)
            x ->
              indicate_typing(message.channel, slack)
          end
        {:unsubscribe, %{id: id}} ->
          indicate_typing(message.channel, slack)
          Devton.Subscriptions.deactivate_subscription(%{"uuid" => id})
        {:tags, %{top: top}} ->
          indicate_typing(message.channel, slack)
          tags = Devton.Library.get_top_tags(String.to_integer(top))
          send_message(Message.tags(tags), message.channel, slack)
        {:help} ->
          indicate_typing(message.channel, slack)
          send_message(Message.help, message.channel, slack)
        {:status} ->
          indicate_typing(message.channel, slack)
          subscriptions = Devton.Subscriptions.get_subscriptions(
            %{
              "user_id" => message.user,
              "workspace_id" => slack.team.id,
            }
          )
          send_message(Message.status(subscriptions), message.channel, slack)
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
