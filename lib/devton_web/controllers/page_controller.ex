defmodule DevtonWeb.PageController do
  use DevtonWeb, :controller

  alias Devton.Subscriptions


  def index(conn, params) do
    render(
      conn,
      "index.html",
      %{
        subscriptions_count: Subscriptions.get_subscriptions_count(),
      }
    )
  end

  def success(conn, params) do
    result = HTTPoison.get!(
               "https://api.giphy.com/v1/gifs/random?api_key=Xp4xStMRfHflzxprqaqEWw3WJknB1FdZ&tag=congrats&rating=r"
             ).body
             |> Poison.decode!
    render(
      conn,
      "success.html",
      %{
        success_img: result["data"]["embed_url"],
      }
    )
  end

  def privacy_policy(conn, %{}), do: render(conn, "privacy-policy.html")

  def contact(conn, %{}), do: render(conn, "contact.html")

  def how_it_works(conn, %{}), do: render(conn, "how-it-works.html")
end
