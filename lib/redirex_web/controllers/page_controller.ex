defmodule RedirexWeb.PageController do
  use RedirexWeb, :controller
  import Plug.Conn

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"url" => url}) do
    conn =
      conn
      |> assign(:url, url)

    Redirex.shortens(url)
    |> case do
      {:ok, code} ->
        {:ok, host} = Redirex.Store.host()

        conn
        |> assign(:result, "#{host}/#{code}")
        |> render("index.html")

      {:error, err} ->
        conn
        |> put_flash(:error, inspect(err))
        |> render("index.html")
    end
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
