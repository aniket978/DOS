defmodule RumourServer do
  use GenServer

  def init() do
    {:ok, {0,0,[],1}}
  end
  def main(args) do
    all_childrens = Enum.map((1..n), fn(node_id) ->
      {:ok, child_id = Genserver.start_link(__MODULE__, [])
      updateChildPID(child_id, node_id)
      child_id
     end)
     build_toplogy(type, all_childrens)
  end
  def build_topology(type, nodes) do
    case type do
      "full" -> build_full(nodes)
      "line" -> build_line(nodes)
    end
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
    propogateGossip(random_node)
  end

  def propogate_gossip(node) do
    node_count = get_count(random_node)
    cond do
      node_count < 11 ->
        node_neighbours = get_neighbours(random_node)
        node_random_neighbour = Enum.Random(node_neighbours)
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
  def update_count(process_id) do
    GenServer.call(process_id, {:updateCount})
  end

# Callbacks

  def handle_call({:updatePID, node_id}, _from, state) do
    {id, count, neighbours, weight} = state
    state = {node_id, count, neighbours, weight}
    {:reply, node_id, state}
  end

  def handle_call({:updateCount} _from, state) do
    {_, count, _, _} = state
    state = {_, count+1, _, _}
    {:reply, count+1, state}
  end

  def handle_call({:updateNeighbours, neighbours}, _from, state) do
    {id, _, list, _} = state
    state = {id, _, neighbours, _}
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
