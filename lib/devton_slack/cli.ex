defmodule DevtonSlack.Cli do
  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> DevtonSlack.Cli.parse_command("devton subscribe -t javascript,wfeda,ews -c \"0 12 * * 1\"")
      {:ok, [:subscribe, "0 12 * * 1", "javascript,wfeda,ews"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe -t \"javascript\" -c \"0 12 * * 1\"")
      {:ok, [:subscribe, "0 12 * * 1", "javascript"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe --tags \"javascript,ruby\" -c \"0 12 * * 2\"")
      {:ok, [:subscribe, "0 12 * * 2", "javascript,ruby"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe --tags \"javascript, ruby \" -c \"0 12 * * 2\"")
      {:ok, [:subscribe, "0 12 * * 2", "javascript,ruby"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe --tags \"javascript\" --cron \"0 12 * * 1\"")
      {:ok, [:subscribe, "0 12 * * 1", "javascript"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe -t \"javascript\" --cron \"0 12 * * 1\"")
      {:ok, [:subscribe, "0 12 * * 1", "javascript"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe -c \"0 12 * * 1\" -t \"javascript\"")
      {:ok, [:subscribe, "0 12 * * 1", "javascript"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe --cron \"0 12 * * 1\" -t \"javascript\"")
      {:ok, [:subscribe, "0 12 * * 1", "javascript"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe --cron \"0 12 * * 1\" --tags \"javascript\"")
      {:ok, [:subscribe, "0 12 * * 1", "javascript"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe -c \"0 12 * * 1\" --tags \"javascript\"")
      {:ok, [:subscribe, "0 12 * * 1", "javascript"]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe -h")
      {:ok, [:help]}

      iex> DevtonSlack.Cli.parse_command("devton subscribe --help")
      {:ok, [:help]}

      iex> DevtonSlack.Cli.parse_command("devton unsubscribe --help")
      {:ok, [:help]}

      iex> DevtonSlack.Cli.parse_command("devton unsubscribe -h")
      {:ok, [:help]}

      iex> DevtonSlack.Cli.parse_command("devton -h")
      {:ok, [:help]}

      iex> DevtonSlack.Cli.parse_command("devton --help")
      {:ok, [:help]}

      iex> DevtonSlack.Cli.parse_command("devton")
      {:ok, [:help]}

      iex> DevtonSlack.Cli.parse_command("")
      {:error, :invalid_command}

      iex> DevtonSlack.Cli.parse_command("devton subscribe -t \"javascript\" -c 0 12 * * 1\"")
      {:error, :invalid_command}

      iex> DevtonSlack.Cli.parse_command("devton subscribe -t javascript,grds,we -c 0 12 * * 1")
      {:error, :invalid_command}

  """
  def parse_command(command) do
    case command
         |> replace_spaces_by_dashes
         |> String.split do
      ["devton", "subscribe"] ->
        {:error, :missing_parameters}
      ["devton", "subscribe", "-c", cron, "-t", tags] ->
        {:ok, [:subscribe, convert_cron(cron), convert_tags(tags)]}
      ["devton", "subscribe", "--cron", cron, "-t", tags] ->
        {:ok, [:subscribe, convert_cron(cron), convert_tags(tags)]}
      ["devton", "subscribe", "--cron", cron, "--tags", tags] ->
        {:ok, [:subscribe, convert_cron(cron), convert_tags(tags)]}
      ["devton", "subscribe", "-c", cron, "--tags", tags] ->
        {:ok, [:subscribe, convert_cron(cron), convert_tags(tags)]}
      ["devton", "subscribe", "-t", tags, "-c", cron] ->
        {:ok, [:subscribe, convert_cron(cron), convert_tags(tags)]}
      ["devton", "subscribe", "--tags", tags, "-c", cron] ->
        {:ok, [:subscribe, convert_cron(cron), convert_tags(tags)]}
      ["devton", "subscribe", "--tags", tags, "--cron", cron] ->
        {:ok, [:subscribe, convert_cron(cron), convert_tags(tags)]}
      ["devton", "subscribe", "-t", tags, "--cron", cron] ->
        {:ok, [:subscribe, convert_cron(cron), convert_tags(tags)]}
      ["devton", "subscribe", "--help"] ->
        {:ok, [:help]}
      ["devton", "subscribe", "-h"] ->
        {:ok, [:help]}
      ["devton", "unsubscribe", "--help"] ->
        {:ok, [:help]}
      ["devton", "unsubscribe", "-h"] ->
        {:ok, [:help]}
      ["devton", "unsubscribe"] ->
        {:ok, [:unsubscribe]}
      ["devton", "-h"] ->
        {:ok, [:help]}
      ["devton", "--help"] ->
        {:ok, [:help]}
      ["devton"] ->
        {:ok, [:help]}
      _ ->
        {:error, :invalid_command}
    end
  end

  defp replace_spaces_by_dashes(command) do
    String.split(command, "\"")
    |> Enum.with_index
    |> Enum.map(
         fn {x, i} ->
           case i do
             1 ->
               join x
             3 ->
               join x
             _ ->
               x
           end
         end
       )
    |> Enum.reduce(
         fn x, acc ->
           "#{acc}\"#{x}"
         end
       )
  end

  defp convert_cron(str) do
    str
    |> String.replace("\\", "")
    |> String.replace("\"", "")
    |> String.replace("=", " ")
  end

  defp convert_tags(str) do
    str
    |> String.replace("\\", "")
    |> String.replace("\"", "")
    |> String.replace("=", "")
  end

  defp join(a) do
    a
    |> String.trim
    |> String.split
    |> Enum.join("=")
  end
end
