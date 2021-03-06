# Project2
**Gossip simulator**

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
*Note:* Also used a Matrix module which converts list into maps of maps which can act as a 2d grid. Refer here https://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir/

# Group Info
 - Anip Mehta  UFID : 96505636
 - Aniket Sinha UFID : 69598035


# DOS Task2

** Implementation of Gossip and Push-Sum algorithms in Elixir**

What is working?

The algorithms : 'gossip' and 'push-sum' for the following topologies:
```
1.line
2.imperfect-line
3.random-2d
4.torus
5.full
6.3d
```
What is the largest network you managed to deal with for each type of topology and algorithm?

- Following is the table showing the maximum problem size(the number of nodes) that the Gossip Algorithm solved for each topology :

```
Topology	      Number of Nodes(Max. Problem size) 	   
--------------------------------------------------
Line                    25             
Imperfect-Line         20000      
Random-2D              5000        
Torus                  20000
Fully connected        15000
3D                      10
```

- Following is the table showing the maximum problem size(the number of nodes) that the Push-Sum Algorithm solved for each topology :

```
Topology	      Number of Nodes(Max. Problem size) 	   
--------------------------------------------------
Line                     100            
Imperfect-Line          10000   
Random-2D               10000       
Torus                   10000
Fully connected         50000
3D                      15000
```



# Instructions
## Input

Syntax:
 - mix run proj2.exs (number of nodes) (topology) (algorithm)
 
 Examples:
 - ``mix run proj2.exs 1000 random-2d gossip``

 - ``mix run proj2.exs 1000 torus push-sum``
 
 The topology above can accept the following values :
  ```
 line
 imperfect-line
 random-2d
 torus
 full
 3d
 ```
 The algorithm above can accept values:
 ```
 gossip
 push-sum
 ```
Note: 
 The program continues to run in infinite loop even after the algorithm has converged. This is done to ensure that the main process does not die before getting all the print statements on the console. Press Ctrl+C to exit the main process after getting the output.


## Output
 - Convergence Time in milliseconds


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/task1](https://hexdocs.pm/task1).
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/project2](https://hexdocs.pm/project2).

