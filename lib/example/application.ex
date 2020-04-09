defmodule Example.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      %{
        id: GRPC.Server.Supervisor,
        start: {GRPC.Server.Supervisor, :start_link, [{Example.Endpoint, 50051}]},
        type: :supervisor
      }
    ]

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
