defmodule Basic do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, "Hello")
  end
  def init(initial_data) do
    greetings = %{:greeting => initial_data}
    {:ok, greetings}
  end

  def get_my_greeting(process_id) do
    GenServer.call(process_id, {:get_the_greeting})
  end

  def set_my_greeting(process_id, greeting) do
    GenServer.cast(process_id, {:set_the_greeting, greeting})
  end

# Callbacks
  def handle_call({:get_the_greeting}, _from, my_state) do
    current_greeting = Map.get(my_state, :greeting)
    {:reply, current_greeting, my_state}
  end


  def handle_cast({:set_the_greeting, new_greeting}, my_state) do
    new_state = Map.put(my_state, :greeting, new_greeting)
    {:noreply, new_state}
  end
end
