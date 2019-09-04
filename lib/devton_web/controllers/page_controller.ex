defmodule DevtonWeb.PageController do
  use DevtonWeb, :controller

  alias Devton.Subscriptions

  #  def index(conn, %{}), do: render(conn, "index.html", success: false)
  def index(conn, params) do
    success_img = case params["success"] == "true" do
      true ->
        result = HTTPoison.get!("https://api.giphy.com/v1/gifs/random?api_key=Xp4xStMRfHflzxprqaqEWw3WJknB1FdZ&tag=congrats&rating=r").body
                 |> Poison.decode!
        result["data"]["embed_url"]
      false -> ""
    end
    render(
      conn,
      "index.html",
      %{
        success: params["success"] == "true",
        subscriptions_count: Subscriptions.get_subscriptions_count(),
        success_img: success_img,
      }
    )
  end
end
