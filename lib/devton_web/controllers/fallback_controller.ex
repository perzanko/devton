defmodule DevtonWeb.FallbackController do
  use DevtonWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(DevtonWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :bad_command}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(DevtonWeb.ErrorView)
    |> assign(:message, "Bad command")
    |> render(:"422")
  end

  def call(conn, {:error, :command_validation_failure, _command, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(DevtonWeb.ErrorView)
    |> assign(:message, "Command validation error: #{inspect(errors)}")
    |> render(:"422")
  end
end
