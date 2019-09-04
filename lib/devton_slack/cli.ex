defmodule DevtonSlack.Cli do
  @doc ~S"""
  ## Examples

    iex> DevtonSlack.Cli.handle_command("devton")
    {:help}

    iex> DevtonSlack.Cli.handle_command("devton help")
    {:help}

    iex> DevtonSlack.Cli.handle_command("devton -h")
    {:help}

    iex> DevtonSlack.Cli.handle_command("devton --help")
    {:help}

    iex> DevtonSlack.Cli.handle_command("devton status")
    {:status}

    iex> DevtonSlack.Cli.handle_command("test")
    {:invalid_command}

    iex> DevtonSlack.Cli.handle_command("devton test")
    {:invalid_command}

    iex> DevtonSlack.Cli.handle_command("devton subscribe -e")
    {:invalid_command}

    iex> DevtonSlack.Cli.handle_command("devton subscribe -e -t")
    {:invalid_command}

    iex> DevtonSlack.Cli.handle_command("devton subscribe -t")
    {:invalid_command}

    iex> DevtonSlack.Cli.handle_command("devton subscribe -t javascript,elixir")
    {:invalid_command}

    iex> DevtonSlack.Cli.handle_command("devton subscribe -t javascript,elixir -d \"monday\"")
    {:invalid_command}

    iex> DevtonSlack.Cli.handle_command("devton subscribe -t javascript,elixir -d \"monday\" --time 10:00")
    {:subscribe, %{ tag: "javascript,elixir", day: "monday", time: "10:00" }}

    iex> DevtonSlack.Cli.handle_command("devton subscribe -t javascript,elixir -d \"monday\" --time 10:00 --help")
    {:invalid_command}

    iex> DevtonSlack.Cli.handle_command("devton unsubscribe --id 10")
    {:unsubscribe, %{ id: "10" }}

    iex> DevtonSlack.Cli.handle_command("devton unsubscribe --id \"10\"")
    {:unsubscribe, %{ id: "10" }}

    iex> DevtonSlack.Cli.handle_command("devton tags --top 10")
    {:tags, %{ top: "10" }}

  """
  def handle_command(command) do
     command
     |> split_command
     |> detect_command
     |> parse_args
     |> transform_args_to_map
     |> validate_args_map
  end

  @doc ~S"""
  Splits command to an list-like command

  ## Examples

    iex> DevtonSlack.Cli.split_command("devton subscribe")
    ["devton", "subscribe"]

    iex> DevtonSlack.Cli.split_command("devton subscribe ")
    ["devton", "subscribe"]

    iex> DevtonSlack.Cli.split_command("devton subscribe test")
    ["devton", "subscribe", "test"]

    iex> DevtonSlack.Cli.split_command("devton \"subscribe test\"")
    ["devton", "subscribe test"]

  """
  def split_command(command) do
    OptionParser.split(command)
  end

  @doc ~S"""
  ## Examples

    iex> DevtonSlack.Cli.detect_command(["devton", "subscribe"])
    {:subscribe, []}

    iex> DevtonSlack.Cli.detect_command(["devton", "subscribe", "--test", "test"])
    {:subscribe, [ "--test", "test" ]}

    iex> DevtonSlack.Cli.detect_command(["devton", "unsubscribe", "--test", "test", "test"])
    {:unsubscribe, [ "--test", "test", "test" ]}

    iex> DevtonSlack.Cli.detect_command(["devton", "status", "--test", "test"])
    {:status}

    iex> DevtonSlack.Cli.detect_command(["devton", "--help"])
    {:help}

    iex> DevtonSlack.Cli.detect_command(["devton", "--test", "test"])
    {:invalid_command}

  """
  def detect_command(args_list) do
    case args_list do
      ["devton" | ["subscribe" | args]] -> {:subscribe, args}
      ["devton" | ["unsubscribe" | args]] -> {:unsubscribe, args}
      ["devton" | ["tags" | args]] -> {:tags, args}
      ["devton" | ["status" | args]] -> {:status}
      ["devton", "--help"] -> {:help}
      ["devton", "-h"] -> {:help}
      ["devton", "help"] -> {:help}
      ["devton"] -> {:help}
      _ -> {:invalid_command}
    end
  end

  @doc ~S"""
  ## Examples

    iex> DevtonSlack.Cli.parse_args({ :subscribe, [] })
    {:subscribe, []}

    iex> DevtonSlack.Cli.parse_args({ :subscribe, ["--tag", "javascript,elixir", "-k"] })
    {:invalid_command}

    iex> DevtonSlack.Cli.parse_args({ :subscribe, ["--tag", "javascript,elixir"] })
    {:subscribe, [tag: "javascript,elixir"]}

    iex> DevtonSlack.Cli.parse_args({ :subscribe, ["-t", "javascript,elixir"] })
    {:subscribe, [tag: "javascript,elixir"]}

    iex> DevtonSlack.Cli.parse_args({ :unsubscribe, ["--id", "10"] })
    {:unsubscribe, [id: "10"]}

    iex> DevtonSlack.Cli.parse_args({ :tags, ["--top", "10"] })
    {:tags, [top: "10"]}

    iex> DevtonSlack.Cli.parse_args({ :unsubscribe, ["-t", "javascript,elixir", "--time", "10:00"] })
    {:invalid_command}

    iex> DevtonSlack.Cli.parse_args({ :help })
    {:help}

  """
  def parse_args(command_tuple) do
    try do
      case command_tuple do
        {:subscribe, args} ->
          {validated_args, _} = OptionParser.parse!(
            args,
            [
              aliases: [
                d: :day,
                m: :time,
                t: :tag
              ],
              strict: [
                day: :string,
                time: :string,
                tag: :string
              ]
            ]
          )
          {:subscribe, validated_args}
        {:unsubscribe, args} ->
          {validated_args, _} = OptionParser.parse!(
            args,
            [
              strict: [
                id: :string
              ]
            ]
          )
          {:unsubscribe, validated_args}
        {:tags, args} ->
          {validated_args, _} = OptionParser.parse!(
            args,
            [
              strict: [
                top: :string
              ]
            ]
          )
          {:tags, validated_args}
        x -> x
      end
    rescue
      _ -> {:invalid_command}
    end
  end

  @doc ~S"""
  ## Examples

    iex> DevtonSlack.Cli.transform_args_to_map({ :help })
    {:help}

    iex> DevtonSlack.Cli.transform_args_to_map({ :subscribe, [] })
    {:subscribe, %{}}

    iex> DevtonSlack.Cli.transform_args_to_map({ :subscribe, [ time: "10:00" ] })
    {:subscribe, %{ time: "10:00" }}

    iex> DevtonSlack.Cli.transform_args_to_map({ :subscribe, [ time: "10:00", tag: "javascript,elixir" ] })
    {:subscribe, %{ time: "10:00", tag: "javascript,elixir" }}

  """
  def transform_args_to_map(command_tuple) do
    case command_tuple do
      {cmd, args} ->
        {cmd, Enum.into(args, %{})}
      x ->
        x
    end
  end

  @doc ~S"""
  ## Examples

    iex> DevtonSlack.Cli.validate_args_map({ :help })
    {:help}

    iex> DevtonSlack.Cli.validate_args_map({ :invalid_command })
    {:invalid_command}

    iex> DevtonSlack.Cli.validate_args_map({ :status })
    {:status}

    iex> DevtonSlack.Cli.validate_args_map({ :subscribe, %{}})
    {:invalid_command}

    iex> DevtonSlack.Cli.validate_args_map({ :subscribe, %{ time: "10:00" }})
    {:invalid_command}

    iex> DevtonSlack.Cli.validate_args_map({ :subscribe, %{ time: "10:00", day: "monday" }})
    {:invalid_command}

    iex> DevtonSlack.Cli.validate_args_map({ :subscribe, %{ time: "10:00", day: "monday", tag: "javascript" }})
    {:subscribe, %{ time: "10:00", day: "monday", tag: "javascript" }}

    iex> DevtonSlack.Cli.validate_args_map({ :unsubscribe, %{}})
    {:invalid_command}

    iex> DevtonSlack.Cli.validate_args_map({ :unsubscribe, %{ id: "1" }})
    {:unsubscribe, %{ id: "1" }}

  """
  def validate_args_map(command_tuple) do
    case command_tuple do
      {:subscribe, args} = command ->
        case Skooma.valid?(args, %{
          tag: :string,
          time: :string,
          day: :string,
        }) do
          {:error, _} -> {:invalid_command}
          _ -> command
        end
      {:unsubscribe, args} = command ->
        case Skooma.valid?(args, %{
          id: :string,
        }) do
          {:error, _} -> {:invalid_command}
          _ -> command
        end
      {:tags, args} = command ->
        case Skooma.valid?(args, %{
          top: :string,
        }) do
          {:error, _} -> {:invalid_command}
          _ -> command
        end
      x ->
        x
    end
  end
end
