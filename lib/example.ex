defmodule Example do
  def hello do
    :world
  end
  
  # send and receive only one message
  def unary do
    {:ok, channel} = GRPC.Stub.connect("localhost:50051")
    request = Example.HelloRequest.new(name: "test 1")
    Example.Greeter.Stub.say_hello(channel, request)
  end

  # client sends one message gets multiple by the server
  def server_stream do
    {:ok, channel} = GRPC.Stub.connect("localhost:50051")
    request = Example.HelloRequest.new(name: "test 1")

    Example.Greeter.Stub.get_multiple_hello(channel, request)
    |> elem(1)
    |> Stream.map(fn {:ok, res} -> res.payload.body end)
    |> Enum.to_list
  end

  # client sends an stream, server returns only one message
  def client_stream do
    {:ok, channel} = GRPC.Stub.connect("localhost:50051")

    payload1 = Example.Payload.new(body: "Hello 1")
    payload2 = Example.Payload.new(body: "Hello 2")
    req1 = Example.StreamRequest.new(payload: payload1)
    req2 = Example.StreamRequest.new(payload: payload2)

    stream = 
      channel
      |> Example.Greeter.Stub.send_multiple_hello()
      |> GRPC.Stub.send_request(req1)
      |> GRPC.Stub.send_request(req2, end_stream: true)
    
    GRPC.Stub.recv(stream)
  end

  # Client and server send streams
  def full_duplex do
    {:ok, channel} = GRPC.Stub.connect("localhost:50051")

    payload1 = Example.Payload.new(body: "Hello 3")
    payload2 = Example.Payload.new(body: "Hello 4")
    req1 = Example.StreamRequest.new(payload: payload1)
    req2 = Example.StreamRequest.new(payload: payload2)

    stream = 
      channel
      |> Example.Greeter.Stub.full_duplex
      |> GRPC.Stub.send_request(req1)
      |> GRPC.Stub.send_request(req2, end_stream: true)

    GRPC.Stub.recv(stream)
    |> elem(1)
    |> Stream.map(fn {:ok, res} -> res.payload.body end)
    |> Enum.to_list
  end
end
