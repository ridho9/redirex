defmodule RedirexWeb.ApiController do
  use RedirexWeb, :controller
  import Plug.Conn

  def create(conn, %{"url" => url}) do
    IO.inspect(url)

    conn =
      conn
      |> put_resp_content_type("application/json")

    Redirex.shortens(url)
    |> case do
      {:ok, code} ->
        res =
          %{"result" => code}
          |> Jason.encode!()

        conn
        |> send_resp(201, res)

      {:error, err} ->
        res =
          %{"message" => inspect(err)}
          |> Jason.encode!()

        conn
        |> send_resp(400, res)
    end
  end
end
