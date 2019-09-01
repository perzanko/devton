defmodule Devton.Support.Service.CronTab do
  @doc ~S"""
  ## Examples

    iex> Devton.Support.Service.CronTab.convert_to_cron_tabs("*", "10:00")
    {:ok, ["00 10 * * *"]}

    iex> Devton.Support.Service.CronTab.convert_to_cron_tabs("monday", "1:00")
    {:ok, ["00 1 * * 1"]}

    iex> Devton.Support.Service.CronTab.convert_to_cron_tabs("*", "10:00,9:11")
    {:ok, ["00 10 * * *", "11 9 * * *"]}

    iex> Devton.Support.Service.CronTab.convert_to_cron_tabs("tuesday, friday", "10:00,19:30")
    {:ok, ["00 10 * * 2,5", "30 19 * * 2,5"]}

    iex> Devton.Support.Service.CronTab.convert_to_cron_tabs("tuesday, test", "00:00")
    {:error, :invalid_day}

    iex> Devton.Support.Service.CronTab.convert_to_cron_tabs("tuesday, test", "test")
    {:error, :invalid_time}

  """
  def convert_to_cron_tabs(day, time) do
    try do
      {
        :ok,
        Enum.map(
          String.split(time, ","),
          fn single_time ->
            {"*", "*", "*", "*", "*"}
            |> parse_time(single_time)
            |> parse_day(day)
            |> Tuple.to_list
            |> Enum.join(" ")
          end
        )
      }
    catch
      e -> {:error, e}
    end
  end

  defp parse_time(tab, time) do
    try do
      [hour, minute] = String.split(time, ":")
      tab
      |> put_elem(0, minute)
      |> put_elem(1, hour)
      |> validate_time!
    rescue
      _ -> throw :invalid_time
    catch
      _ -> throw :invalid_time
    end
  end

  defp parse_day(tab, day) do
    try do
      case day do
        "*" ->
          tab
        _ ->
          parsed_day = day
                       |> String.downcase()
                       |> String.replace(" ", "")
                       |> String.replace("monday", "1")
                       |> String.replace("monday", "1")
                       |> String.replace("tuesday", "2")
                       |> String.replace("wednesday", "3")
                       |> String.replace("thursday", "4")
                       |> String.replace("friday", "5")
                       |> String.replace("saturday", "6")
                       |> String.replace("sunday", "0")
          put_elem(tab, 4, parsed_day)
          |> validate_day!
      end
    rescue
      _ -> throw :invalid_day
    catch
      _ -> throw :invalid_day
    end
  end

  defp validate_day!({_, _, _, _, day} = tab) do
    case String.match?(day, ~r/^(([0-9]?)+(,?))+[0-9]+$/) do
      true -> tab
      false -> throw :invalid_day
    end
  end

  defp validate_time!({minute, hour, _, _, _} = tab) do
    case String.match?(minute, ~r/\d+/) && String.match?(hour, ~r/\d+/) do
      true -> tab
      false -> throw :invalid_time
    end
  end
end
