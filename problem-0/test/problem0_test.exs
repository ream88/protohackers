defmodule Problem0Test do
  use ExUnit.Case

  setup do
    port = String.to_integer(System.get_env("PORT") || "4040")
    {:ok, port: port}
  end

  test "echoes everything back", %{port: port} do
    {:ok, socket} = :gen_tcp.connect(~c"localhost", port, mode: :binary, active: false)
    assert :gen_tcp.send(socket, "foo") == :ok
    assert :gen_tcp.send(socket, "bar") == :ok

    :gen_tcp.shutdown(socket, :write)
    assert :gen_tcp.recv(socket, 0) == {:ok, "foobar"}
  end
end
