defmodule Redirex do
  @moduledoc """
  Redirex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def shortens(url) do
    if ValidUrl.validate(url) do
      unique_string = Redirex.Shortener.generate_random_unique(8)
      Redirex.Store.set(unique_string, url)

      {:ok, "#{unique_string}"}
    else
      {:error, "invalid url"}
    end
  end

  def redirect(code) do
    case Redirex.Store.get(code) do
      nil -> {:error, :not_found}
      v -> {:ok, v}
    end
  end
end
