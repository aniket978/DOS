# Project2

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `project2` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:project2, "~> 0.1.0"}
  ]
end
```

# Group Info
 - Anip Mehta  UFID : 96505636
 - Aniket Sinha UFID : 69598035


# DOS Task2



- Following is the table showing the maximum problem size(the number of nodes) that the Gossip Algorithm solved for each topology :

```
Topology	      Number of Nodes(Max. Problem size) 	   
--------------------------------------------------
Line                    25             
Imperfect-Line         20000      
Random-2D              5000        
Torus                  20000
Fully connected        15000
3D
```

- Following is the table showing the maximum problem size(the number of nodes) that the Push-Sum Algorithm solved for each topology :

```
Topology	      Number of Nodes(Max. Problem size) 	   
--------------------------------------------------
Line                                 
Imperfect-Line               
Random-2D                      
Torus                  
Fully connected 
3D
```



# Instructions
## Input

syntax:
 - mix run proj2.exs (number of nodes) (topology) (algorithm)
 
 Examples:
 - mix run proj2.exs 5000 random-2d gossip

 - mix run proj2.exs 5000 torus gossip
 
 The topology above can accept the following values :
 line
 imperfect-line
 random-2d
 torus
 full
 3d
 
 The algorithm above can accept values:
 gossip
 push-sum
 
Note: 
 The program continues to run in infinite loop even after the algorithm has converged. This is done to ensure that the main process does not die before getting all the print statements on the console.


## Output
 - Convergence Time in milliseconds


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/task1](https://hexdocs.pm/task1).
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/project2](https://hexdocs.pm/project2).

