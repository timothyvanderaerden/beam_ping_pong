defmodule PingPong do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    Process.register(spawn(fn -> pong() end), :pong_process)
    Process.register(spawn(fn -> ping(3) end), :ping_process)
    {:ok, state}
  end

  def ping(0) do
    send(:pong_process, :finished)
    IO.puts("Ping finished")
  end

  def ping(n) do
    send(:pong_process, :ping)

    receive do
      :pong ->
        IO.puts("Ping received pong")
    end

    ping(n - 1)
  end

  def pong do
    receive do
      :finished ->
        IO.puts("Pong finished")

      :ping ->
        IO.puts("Pong received")
        send(:ping_process, :pong)
        pong()
    end
  end
end
