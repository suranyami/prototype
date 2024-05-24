defmodule Prototype.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PrototypeWeb.Telemetry,
      Prototype.Repo,
      {DNSCluster, query: Application.get_env(:prototype, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Prototype.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Prototype.Finch},
      # Start a worker by calling: Prototype.Worker.start_link(arg)
      # {Prototype.Worker, arg},
      # Start to serve requests, typically the last entry
      PrototypeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Prototype.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PrototypeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
