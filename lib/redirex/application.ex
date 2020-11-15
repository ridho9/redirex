defmodule Redirex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RedirexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Redirex.PubSub},
      # Start the Endpoint (http/https)
      RedirexWeb.Endpoint,
      # Start a worker by calling: Redirex.Worker.start_link(arg)
      # {Redirex.Worker, arg}
      {Cachex, name: Redirex.Cache},
      {Redirex.Store, name: Redirex.Store}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Redirex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RedirexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
