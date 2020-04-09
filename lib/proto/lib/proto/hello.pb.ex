defmodule Example.Payload do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          body: binary
        }
  defstruct [:body]

  field :body, 1, type: :bytes
end

defmodule Example.HelloRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t()
        }
  defstruct [:name]

  field :name, 1, type: :string
end

defmodule Example.HelloReply do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t()
        }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule Example.StreamReply do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          payload: Example.Payload.t() | nil
        }
  defstruct [:payload]

  field :payload, 1, type: Example.Payload
end

defmodule Example.StreamRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          payload: Example.Payload.t() | nil
        }
  defstruct [:payload]

  field :payload, 1, type: Example.Payload
end

defmodule Example.Greeter.Service do
  @moduledoc false
  use GRPC.Service, name: "Example.Greeter"

  rpc :SayHello, Example.HelloRequest, Example.HelloReply
  rpc :GetMultipleHello, Example.HelloRequest, stream(Example.StreamReply)
  rpc :SendMultipleHello, stream(Example.StreamRequest), Example.HelloReply
  rpc :FullDuplex, stream(Example.StreamRequest), stream(Example.StreamReply)
end

defmodule Example.Greeter.Stub do
  @moduledoc false
  use GRPC.Stub, service: Example.Greeter.Service
end
