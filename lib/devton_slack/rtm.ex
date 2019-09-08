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

  def handle_event(message = %{type: "message"}, slack, state) do
    try do
      case can_process_command(message.text) do
        false ->
          {:ok, state}
        true ->
          execute_command(message, slack)
          {:ok, state}
      end
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

  defp execute_command(message, slack) do
    command = Cli.handle_command(message.text)
    Logger.info("Message: '#{message.text}', Command: '#{inspect(command)}', channel '#{message.channel}'")
    case command do
      {:subscribe, %{tag: tag, time: time, day: day}} ->
        run_command(:subscribe, tag, time, day, message, slack)
      {:unsubscribe, %{id: id}} ->
        run_command(:unsubscribe, id, message, slack)
      {:tags, %{top: top}} ->
        run_command(:tags, top, message, slack)
      {:help} ->
        run_command(:help, message, slack)
      {:random} ->
        run_command(:random, message, slack)
      {:status} ->
        run_command(:status, message, slack)
      {:invalid_command} ->
        run_command(:invalid_command, message, slack)
    end
  end

  defp run_command(:subscribe, tag, time, day, message, slack) do
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
  end

  defp run_command(:unsubscribe, id, message, slack) do
    indicate_typing(message.channel, slack)
    Devton.Subscriptions.deactivate_subscription(%{"uuid" => id})
  end

  defp run_command(:tags, top, message, slack) do
    indicate_typing(message.channel, slack)
    tags = Devton.Library.get_top_tags(String.to_integer(top))
    send_message(Message.tags(tags), message.channel, slack)
  end

  defp run_command(:help, message, slack) do
    indicate_typing(message.channel, slack)
    send_message(Message.help, message.channel, slack)
  end

  defp run_command(:status, message, slack) do
    indicate_typing(message.channel, slack)
    subscriptions = Devton.Subscriptions.get_subscriptions(
      %{
        "user_id" => message.user,
        "workspace_id" => slack.team.id,
      }
    )
    send_message(Message.status(subscriptions), message.channel, slack)
  end

  defp run_command(:random, message, slack) do
    indicate_typing(message.channel, slack)
    [subscription | subscriptions] = Devton.Subscriptions.get_subscriptions(
      %{
        "user_id" => message.user,
        "workspace_id" => slack.team.id,
      }
    )
    if subscription.uuid !== nil do
      Devton.Subscriptions.perform_send(
        %{
          "uuid" => subscription.uuid,
          "random" => true,
        }
      )
    end
  end

  defp run_command(:invalid_command, message, slack) do
    indicate_typing(message.channel, slack)
    send_message(Message.invalid_command, message.channel, slack)
  end

  defp can_process_command(text) do
    if String.contains?(text, "Do Not Disturb"), do: false
    if String.contains?(text, "snoozed notifications"), do: false
    true
  end
end
