defmodule Example.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Logger.Server
  run Example.Server
end