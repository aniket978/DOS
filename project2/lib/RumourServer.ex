defmodule RumourServer do
  use GenServer

  def main(args) do
    IO.puts(args)
    algorithm = "gossip"
    topology = "sphere"
    n = 100
    :random.seed(:erlang.now)
    all_childrens = Enum.map((1..n), fn(node_id) ->
      {_, child_id} = GenServer.start_link(__MODULE__, [])
      updateChildPID(child_id, node_id)
      if topology == "random-2d" do
          random_x = :rand.uniform
          random_y = :rand.uniform
          update_child_2D_location(child_id, random_x, random_y)
      end
      child_id
     end)
     build_topology(topology, all_childrens)
     protocol(algorithm, all_childrens)
  end
  def build_topology(type, nodes) do
    case type do
      "full" -> build_full(nodes)
      "line" -> build_line(nodes)
      "imperfect-line" -> build_imperfect_line(nodes)
      "random-2d" -> build_random_2D(nodes)
      "sphere" -> build_sphere(nodes)
    end
  end

  def build_line(nodes) do
    total_nodes = Enum.count(nodes)
    Enum.each(nodes, fn(node) ->
      currentIndex = Enum.find_index(nodes, fn(x) -> x==node end)
      neighbours =
        cond do
          currentIndex+1 == total_nodes ->
            [] ++ [Enum.fetch!(nodes, currentIndex - 1)]
          currentIndex == 0 ->
            [] ++ [Enum.fetch(nodes, currentIndex + 1)]
          true ->
            [] ++ [Enum.fetch!(nodes, currentIndex + 1)] ++ [Enum.fetch!(nodes, currentIndex - 1)]
        end
      update_neighbours(node, neighbours)
    end)
  end

  def build_sphere(nodes) do
    total_nodes = Enum.count(nodes)
    max_row_col = trunc(:math.sqrt(total_nodes))
    list_of_list = Enum.chunk_every(nodes, max_row_col)
    grid = Matrix.from_list(list_of_list)
    mapXY = %{}
    Enum.each(0..max_row_col-1, fn(i)->
      Enum.each(0..max_row_col-1, fn(j) ->
        node_id = Enum.at(Enum.at(list_of_list, i), j)
        update_child_2D_location(node_id, i, j)
        put_in grid[i][j], node_id
      end)
    end)

    Enum.each(nodes, fn(node) ->
      {x, y} = get_2D_coordinates(node)
      IO.puts "co-rd: "<> Integer.to_string(x) <> ", " <> Integer.to_string(y)
      left = if y==0 do grid[x][max_row_col-1] else grid[x][y-1] end
      top = if x==0 do grid[max_row_col-1][y] else grid[x-1][y] end
      right = if y==max_row_col-1 do grid[x][0] else grid[x][y+1] end
      bottom = if x==max_row_col-1 do grid[0][y] else grid[x+1][y] end
      neighbours = [left, top, right, bottom]
      update_neighbours(node, neighbours)
    end)
  end

  def build_imperfect_line(nodes) do
    total_nodes = Enum.count(nodes)
    Enum.each(nodes, fn(node) ->
      currentIndex = Enum.find_index(nodes, fn(x) -> x==node end)
      neighbours =
        cond do
          currentIndex+1 == total_nodes ->
            [] ++ [Enum.fetch!(nodes, currentIndex - 1)]
          currentIndex == 0 ->
            [] ++ [Enum.fetch(nodes, currentIndex + 1)]
          true ->
            [] ++ [Enum.fetch!(nodes, currentIndex + 1)] ++ [Enum.fetch!(nodes, currentIndex - 1)]
        end
      temp_nodes =
        cond do
          currentIndex+1 == total_nodes ->
            List.delete(nodes, currentIndex - 1)
          currentIndex == 0 ->
            List.delete(nodes, currentIndex + 1)
          true ->
            temp = List.delete(nodes, currentIndex + 1)
            List.delete(temp, currentIndex - 1)
        end
      temp_nodes = List.delete(temp_nodes, node)
      random_neighbour = Enum.random(temp_nodes)
      neighbours = neighbours ++ [random_neighbour]
      update_neighbours(node, neighbours)
    end)
  end

  def build_random_2D(nodes) do
    Enum.each(nodes, fn(node) ->
      suspected_neighbours = List.delete(nodes, node)
      {curr_x, curr_y} = get_2D_coordinates(node)
      IO.puts "For coordinate: "<>Float.to_string(curr_x)<>Float.to_string(curr_y)
      valid_neighbours =
        Enum.reduce(suspected_neighbours, fn(suspected_neighbour, neighbours) ->
          {x, y} = get_2D_coordinates(suspected_neighbour)
          distance = :math.pow(curr_x - x, 2) + :math.pow(curr_y - y, 2)
          distance = :math.sqrt(distance)
          neighbours =
            if nil do
              []
            else
              neighbours
            end
          IO.puts "Checking co-or: "<>Float.to_string(x)<>", "<>Float.to_string(y)
            if distance <= 0.5 do
              IO.puts "Found Neighbour"
              [neighbours] ++ [suspected_neighbour]
            else
              neighbours
            end
        end)
      update_neighbours(node, valid_neighbours)
    end)
  end


  def protocol(protocol, nodes) do
    case protocol do
      "gossip" -> initiate_gossip(nodes)
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
    update_count(random_node)
    propogate_gossip(random_node)
  end

  def propogate_gossip(node) do
    node_count = get_count(node)
    cond do
      node_count < 11 ->
        IO.puts("Rumour Heard: "<> Integer.to_string(node_count))
        node_neighbours = get_neighbours(node)
        Enum.reduce(node_neighbours, [], fn(x, l) ->
           if x == node do l else [x | l] end
        end)
        if node_neighbours != nil do
          node_random_neighbour = Enum.random(node_neighbours)
          spread_rumour(node, node_random_neighbour)
        end
        # update_count(node_random_neighbour)
        # propogate_gossip(node_random_neighbour)
      true ->
        IO.puts("Total rumour finished. not Propogating now")
        Process.exit(node, :normal)
    end
      # propogate_gossip(node)
  end

  def update_neighbours(process_id, neighbours) do
    GenServer.call(process_id,{:updateNeighbours, neighbours})
  end

  def updateChildPID(process_id, node_id) do
    GenServer.call(process_id, {:updatePID, node_id})
  end

  def get_neighbours(process_id) do
    GenServer.call(process_id, {:getNeighbours})
  end
  def get_2D_coordinates(process_id) do
    GenServer.call(process_id, {:get2D})
  end
  def get_count(process_id) do
    GenServer.call(process_id, {:getCount})
  end
  def update_count(process_id) do
    GenServer.call(process_id, {:updateCount})
  end
  def update_child_2D_location(process_id, x, y) do
    GenServer.call(process_id, {:update2D, x, y})
  end

  def spread_rumour(process_id, next_neighbour_pid) do
    GenServer.cast(process_id, {:spreadRumour, next_neighbour_pid})
  end

# Callbacks

  def handle_call({:updatePID, node_id}, _from, state) do
    {_, count, neighbours, weight, position} = state
    state = {node_id, count, neighbours, weight, position}
    {:reply, node_id, state}
  end

  def handle_call({:updateCount}, _from, state) do
    {a, count, c, d, e} = state
    state = {a, count+1, c, d, e}
    {:reply, count+1, state}
  end

  def handle_call({:updateNeighbours, neighbours}, _from, state) do
    {id, a, _, b, c} = state
    state = {id, a, neighbours, b, c}
    {:reply, id, state}
  end

  def handle_call({:getNeighbours}, _from, state) do
    {_, _, neighbours, _, _} = state
    {:reply, neighbours, state}
  end

  def handle_call({:getCount}, _from, state) do
    {_, count, _, _, _} = state
    {:reply, count, state}
  end

  def handle_call({:update2D, x, y}, _from, state) do
    {a, b, c, d, {_, _,old_z}} = state
    state = {a, b, c, d, {x, y, old_z}}
    # IO.puts("Co-ordinates:" <> Float.to_string(x)<>", "<> Float.to_string(y))
    {:reply, {x,y}, state}
  end

  def handle_call({:get2D}, _from, state) do
    {_, _, _, _, {x, y, _}} = state
    {:reply, {x,y}, state}
  end

  def handle_cast({:spreadRumour, nextNeighbour}, state) do
    update_count(nextNeighbour)
    propogate_gossip(nextNeighbour)
    {:noreply, state}
  end

  def init([]) do
    {:ok, {0,0,[],1, {0, 0, 0}}}
  end
end
