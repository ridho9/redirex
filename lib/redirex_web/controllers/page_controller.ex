defmodule RedirexWeb.PageController do
  use RedirexWeb, :controller
  import Plug.Conn

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def open(conn, %{"slug" => slug}) do
    case Redirex.redirect(slug) do
      {:ok, url} ->
        conn
        |> put_resp_header("Location", url)
        |> send_resp(301, "yeet")

      {:error, :not_found} ->
        conn
        |> send_resp(404, "code ${slug} not found")
    end
  end
end
