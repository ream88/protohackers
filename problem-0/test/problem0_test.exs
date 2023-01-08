defmodule Problem0Test do
  use ExUnit.Case

  setup do
    port = String.to_integer(System.get_env("PORT") || "4040")
    {:ok, port: port}
  end

  test "echoes everything back", %{port: port} do
    {:ok, socket} = :gen_tcp.connect(~c"localhost", port, mode: :binary, active: false)
    assert :ok = :gen_tcp.send(socket, "foo")
    assert :ok = :gen_tcp.send(socket, "bar")

    :gen_tcp.shutdown(socket, :write)
    assert :gen_tcp.recv(socket, 0) == {:ok, "foobar"}
  end

  test "supports multiple simultaneous clients", %{port: port} do
    {:ok, socket1} = :gen_tcp.connect(~c"localhost", port, mode: :binary, active: false)
    {:ok, socket2} = :gen_tcp.connect(~c"localhost", port, mode: :binary, active: false)

    assert :ok = :gen_tcp.send(socket1, "foo")
    assert :ok = :gen_tcp.send(socket2, "foo")
    assert :ok = :gen_tcp.send(socket1, "bar")
    assert :ok = :gen_tcp.send(socket2, "bar")

    :gen_tcp.shutdown(socket1, :write)
    :gen_tcp.shutdown(socket2, :write)
    assert :gen_tcp.recv(socket1, 0) == {:ok, "foobar"}
    assert :gen_tcp.recv(socket2, 0) == {:ok, "foobar"}
  end
end
