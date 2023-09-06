defmodule AuthSystem.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AuthSystemWeb.Telemetry,
      # Start the Ecto repository
      AuthSystem.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: AuthSystem.PubSub},
      # Start Finch
      {Finch, name: AuthSystem.Finch},
      # Start the Endpoint (http/https)
      AuthSystemWeb.Endpoint
      # Start a worker by calling: AuthSystem.Worker.start_link(arg)
      # {AuthSystem.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthSystemWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
