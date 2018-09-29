defmodule RumourSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, 2)
  end

  def init(initial_data) do
    children = 1..initial_data|> Enum.map(&(worker(Basic, [],id: [&1])))
    supervise(children, strategy: :one_for_one)
  end

  def inform_child_about_neighbours(process_id) do
    [one, two] = Supervisor.which_children(process_id)
    {_, one_pid, _, _} = one
    IO.puts(one_pid)
    GenServer.cast(process_id, {:set_children, one_pid})
  end
  def get_children_pids(process_id) do
    GenServer.call(process_id, {:get_child_list})
  end

  # Callbacks
  def handle_cast({:set_children, child_list}, my_state) do
    new_state = Map.put(my_state, :child_list, child_list)
    {:noreply, new_state}
  end

  def handle_call({:get_child_list}, _from, my_state) do
    child_list = Map.get(my_state, :child_list)
    {:reply, child_list, my_state}
  end

end
