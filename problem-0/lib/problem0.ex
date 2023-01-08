defmodule Problem0 do
  require Logger

  def start(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, mode: :binary, active: false, reuseaddr: true, exit_on_close: false)

    Logger.info("Accepting connections on port #{port}")
    loop(socket)
  end

  defp loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} =
      Task.Supervisor.start_child(Problem0.TaskSupervisor, fn ->
        Logger.info("Client connected")
        serve(client)
        :gen_tcp.close(client)
      end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop(socket)
  end

  defp serve(socket) do
    {:ok, data} = recv_until_closed(socket, [])
    Logger.info("Sending data back to client")
    :gen_tcp.send(socket, data)
  end

  defp recv_until_closed(socket, buffer) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} -> recv_until_closed(socket, [buffer, data])
      {:error, :closed} -> {:ok, buffer}
      {:error, reason} -> {:error, reason}
    end
  end
end
