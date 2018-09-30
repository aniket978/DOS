defmodule RumourServer do
  use GenServer

  def init() do
    {:ok, {0,0,[],1}}
  end

  def main(args) do
    {n, type} = args
    all_childrens = Enum.map((1..n), fn(node_id) ->
      {:ok, child_id} = Genserver.start_link(__MODULE__, [])
      updateChildPID(child_id, node_id)
      child_id
     end)
     build_topology(type, all_childrens)
  end

  def build_topology(type, nodes) do
    case type do
      "full" -> build_full(nodes)
      "line" -> build_line(nodes)
    end
  end

def build_line(nodes) do

end

  def build_full(nodes) do
    Enum.each(nodes, fn(node) ->
      neighbours = List.delete(nodes, node)
      update_neighbours(node, neighbours)
    end)
  end

  def initiate_gossip(nodes) do
    random_node = Enum.random(nodes)
    update_gossip_count(random_node)
    propogate_gossip(random_node)
  end

  def propogate_gossip(node) do
    node_count = get_count(node)
    cond do
      node_count < 11 ->
        node_neighbours = get_neighbours(node)
        node_random_neighbour = Enum.random(node_neighbours)
        propogate_gossip(node_random_neighbour)
      true ->
        Process.exit(node, :normal)
    end
      propogate_gossip(node)
  end

  def update_neighbours(process_id, neighbours) do
    GenServer.call(process_id,{:updateNeighbours, neighbours})
  end

  def updateChildPID(process_id, node_id) do
    Genserver.call(process_id, {:updatePID, node_id})
  end

  def get_neighbours(process_id) do
    GenServer.call(process_id, {:getNeighbours})
  end
  def get_count(process_id) do
    GenServer.call(process_id, {:getCount})
  end
  def update_gossip_count(process_id) do
    GenServer.call(process_id, {:updateCount})
  end

# Callbacks

  def handle_call({:updatePID, node_id}, _from, state) do
    {id, count, neighbours, weight} = state
    state = {node_id, count, neighbours, weight}
    {:reply, node_id, state}
  end

  def handle_call({:updateCount}, _from, state) do
    {a, count, c, d} = state
    # Fixing error : invalid use of _. "_" represents a value to be ignored in a pattern and cannot be used in expressions
    state = {a, count+1, c, d}
    {:reply, count+1, state}
  end

  def handle_call({:updateNeighbours, neighbours}, _from, state) do
    {id, b, list, d} = state
    state = {id, b, neighbours, d}
    {:reply, id, state}
  end

  def handle_call({:getNeighbours}, _from, state) do
    {_, _, neighbours, _} = state
    {:reply, neighbours, state}
  end

  def handle_call({:getCount}, _from, state) do
    {_, count, _, _} = state
    {:reply, count, state}
  end

end
