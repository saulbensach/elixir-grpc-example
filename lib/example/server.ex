defmodule Example.Server do
  use GRPC.Server, service: Example.Greeter.Service

  # Unary response
  @spec say_hello(Example.HelloRequest.t, GRPC.Server.Stream.t) :: Example.HelloReply.t
  def say_hello(request, _stream) do
    Example.HelloReply.new(message: "Hello #{request.name}")
  end

  @spec say_hello(Example.HelloRequest.t, GRPC.Server.Stream.t) ::  GRPC.Server.Stream.t
  def get_multiple_hello(request, stream) do
    1..50
    |> Enum.map(fn n -> 
      payload = Example.Payload.new(body: "#{n}")
      reply = Example.StreamReply.new(payload: payload)
      GRPC.Server.send_reply(stream, reply)
    end)
  end

  @spec send_multiple_hello(Example.StreamRequest.t, GRPC.Server.Stream.t) ::  Example.HelloReply.t
  def send_multiple_hello(request, stream) do
    resp = Enum.map(request, fn req -> 
      req.payload.body
    end)
    
    Example.HelloReply.new(message: "Hello #{resp}")
  end

  def full_duplex(request, stream) do
    Enum.each(request, fn req ->
      payload = Example.Payload.new(body: "Hello and #{req.payload.body}")
      reply = Example.StreamReply.new(payload: payload)
      GRPC.Server.send_reply(stream, reply)
    end)
  end
end