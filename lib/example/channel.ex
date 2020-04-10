defmodule Example.Channel do
  use GenServer

  @timeout 10000

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  # for doing unary or server_stream calls
  def unary(module, function, request) do
    :poolboy.transaction(
      :channel,
      fn pid -> GenServer.call(pid, {:unary, module, function, request}) end,
      @timeout
    )
  end

  def client_stream(module, function, requests) do
    :poolboy.transaction(
      :channel,
      fn pid -> GenServer.call(pid, {:client_stream, module, function, requests}) end,
      @timeout
    )
  end

  def init(opts) do
    {:ok, opts, {:continue, :connect}}
  end
  
  def handle_continue(:connect, state) do
    {:ok, channel} = GRPC.Stub.connect("localhost:50051")
    {:noreply, channel}
  end

  def handle_call({:unary, module, function, request}, _from, channel) do
    response = apply(module, function, [channel, request])
    {:reply, response, channel}
  end

  def handle_call({:client_stream, module, function, requests}, _from, channel) do
    result = 
      module
      |> apply(function, [channel])
      |> create_stream(requests)
      |> GRPC.Stub.recv

    {:reply, result, channel}
  end

  defp create_stream(stream, []) do
    GRPC.Stub.end_stream(stream)
  end
  defp create_stream(stream, [payload | payloads]) do
    request = Example.StreamRequest.new(payload: payload)
    stream = GRPC.Stub.send_request(stream, request)
    create_stream(stream, payloads)
  end
end