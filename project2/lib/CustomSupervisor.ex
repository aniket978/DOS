defmodule Basic do
  use GenServer

  @server_name __MODULE__
  def start_link(i) do
    IO.puts "Process #{i} "
    GenServer.start_link(@server_name,[i])
  end

  def init([i]) do
    {:ok, []}
  end

end

defmodule CustomSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__,[])
  end

  def init() do
    children = 1..5|> Enum.map(&(worker(Basic,[&1],id: "my_worker_"<>Integer.to_string(&1))))
    opts = [strategy: :one_for_one, name: CustomSupervisor]

    Supervisor.init(children, opts)
  end
end

CustomSupervisor.start_link()
