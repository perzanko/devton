defmodule Devton.SchedulerManager do
  use GenServer
  require Logger
  import Crontab.CronExpression

  alias Devton.{Scheduler, Subscriptions}

  @delay 0

  # Client

  def start_link, do:
    GenServer.start_link(__MODULE__, [], name: SchedulerManager)

  def refresh_subscriptions(delay \\ @delay),
      do: GenServer.cast(SchedulerManager, {:refresh_subscriptions, delay})

  def remove_subscription(%{"uuid" => uuid}, delay \\ @delay),
      do: GenServer.cast(SchedulerManager, {:remove_subscription, uuid, delay})

  # Server (callbacks)

  @impl true
  def init(stack) do
    refresh_subscriptions()
    {:ok, stack}
  end

  @impl true
  def handle_cast({:refresh_subscriptions, delay}, state) do
    :timer.sleep(delay)
    Subscriptions.get_subscriptions(%{"active" => true})
    |> Enum.each(
         fn subscription ->
           subscription.cron_tabs
           |> Enum.with_index
           |> Enum.each(
                fn {cron_tab, index} ->
                  subscription_job_id = covert_uuid_to_atom_value "#{subscription.uuid}_#{index}"
                  scheduled_job = Scheduler.find_job subscription_job_id
                  case scheduled_job do
                    nil ->
                      create_job(subscription_job_id, subscription, cron_tab)
                      Logger.info "Subscription job scheduled, id: #{subscription_job_id}, cron: #{
                        cron_tab
                      }, timezone: #{
                        subscription.user["timezone"]
                      }"
                    _ ->
                  end
                end
              )
         end
       )
    {:noreply, state}
  end

  @impl true
  def handle_cast({:remove_subscription, uuid, delay}, state) do
    :timer.sleep(delay)
    case Subscriptions.get_subscription(%{"uuid" => uuid}) do
      {:ok, subscription} ->
        subscription.cron_tabs
        |> Enum.with_index
        |> Enum.each(
             fn {cron_tab, index} ->
               subscription_job_id = "#{subscription.uuid}_#{index}"
               subscription_job_id
               |> covert_uuid_to_atom_value
               |> remove_job

               Logger.info "Subscription job removed, id: #{subscription_job_id}, cron: #{cron_tab}, timezone: #{
                 subscription.user["timezone"]
               }"
             end
           )
      _ ->
    end
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp create_job(subscription_job_id, subscription, cron_tab) do
    Scheduler.new_job
    |> Quantum.Job.set_name(subscription_job_id)
    |> Quantum.Job.set_schedule(parse_cron_tab(cron_tab))
    |> Quantum.Job.set_timezone(subscription.user["timezone"])
    |> Quantum.Job.set_task(
         fn -> perform_send(subscription.uuid) end
       )
    |> Scheduler.add_job
  end

  defp remove_job(name),
       do: Scheduler.delete_job(name)

  defp covert_uuid_to_atom_value(uuid),
       do: uuid
           |> String.replace("-", "")
           |> String.to_atom

  defp parse_cron_tab(cron_tab) do
    {:ok, cron_tab_parsed} = Crontab.CronExpression.Parser.parse(cron_tab)
    cron_tab_parsed
  end

  defp perform_send(uuid), do: Subscriptions.perform_send(%{"uuid" => uuid})
end
