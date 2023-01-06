defmodule Problem0 do
  require Logger

  def start(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop(socket)
  end

  defp loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    echo(client)
    loop(socket)
  end

  defp echo(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        :gen_tcp.send(socket, data)
        echo(socket)

      {:error, error} ->
        Logger.error("Error #{inspect(error)}")
    end
  end
end
