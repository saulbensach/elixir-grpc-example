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
      },
      :poolboy.child_spec(:channel, pool_config())
    ]

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp pool_config do
    [
      name: {:local, :channel},
      worker_module: Example.Channel,
      size: 10,
      max_overflow: 10
    ]
  end
end
