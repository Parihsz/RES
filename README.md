# RES
✖️⚡ A Fast & Comprehensive Math Library written in Lua

## Install
https://www.roblox.com/library/14620044446/RES

## Graphs
I designed the Graphs library to allow for fast and efficient graph operations in Lua. It provides functionalities for creating and manipulating both directed and undirected graphs. The library supports common graph algorithms such as Depth First Search (DFS), Breadth First Search (BFS), Dijkstra's algorithm for shortest path, and some utility functions like checking connectivity and degree of a vertex.

### Usage:

#### Creating a Graph:
```lua
local Graphs = require path.to.Graphs

local vertices = {1, 2, 3, 4, 5}
local edges = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 1}}

local graph = Graphs.Graph:new(vertices, edges)
```
#### Adding an edge:
You can add an edge between two vertices with an optional weight (default weight is 1).
```lua
graph:AddEdge(1, 2, 10)
```

#### Depth First Search (DFS): 
You can perform a DFS from a given start vertex.
```lua
graph:DFS(1)
```
#### Breadth First Search (BFS): 
You can perform a BFS from a given start vertex.
```lua
graph:BFS(1)
```

#### Dijkstra's Algorithm: 
You can find the shortest paths from a given start vertex to all other vertices.
```lua
local distances, previous = graph:Dijkstra(1)
```

#### Check if Graph is Connected: 
You can check if the graph is connected.
```lua
local isConnected = graph:IsConnected()
```

#### Get Degree of Vertex: 
You can get the degree of a given vertex.
```lua
local degree = graph:GetDegree(1)
```

#### Working with Adjacent Vertices: 
You can retrieve the adjacent vertices of a given vertex.
```lua
local adjacentVertices = graph:GetAdjacentVertices(1)
```

## Matrices
The Matrices library was created to provide comprehensive matrix operations in lua. The library allows for creation, manipulation, and calculations with matrices of various dimensions. The library covers matrix operations such as addition, subtraction, multiplication, transposition, LU decomposition, determinant calculation, and matrix inversion. 

### Usage:
```lua
local Matrix = require path.to.Matrix

local matrixA = Matrix.new(3, 3, {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}})
local matrixB = Matrix.new(3, 3, {{9, 8, 7}, {6, 5, 4}, {3, 2, 1}})

local sum = matrixA + matrixB
local product = matrixA * matrixB
local transposeA = matrixA:Transpose()
local determinantA = matrixA:Determinant()
local inverseA = matrixA:Inverse()

print("Sum:", sum)            -- Outputs a matrix representing the sum
print("Product:", product)    -- Outputs a matrix representing the product
print("Transpose:", transposeA) -- Outputs the transposed matrix
print("Determinant:", determinantA) -- Outputs the determinant of the matrix
print("Inverse:", inverseA)   -- Outputs the inverse of the matrix
```

## Scalars
I built the Scalars library to provide fast and efficient arithmetic operations on integers in a modular setting (ZmodP) and real-valued scalar functions. The library includes functionalities for addition, subtraction, multiplication, exponentiation, inverse in modular arithmetic, and general scalar operations like square root, sine, cosine, and natural logarithm.

### Usage:

#### General Functions
```lua
local Scalars = require(script.Scalars)

local value = 25
local sqrtValue = Scalars:Sqrt(value)
print("Square Root of", value, "is", sqrtValue)

local sinValue = Scalars:Sin(value)
print("Sine of", value, "is", sinValue)

local cosValue = Scalars:Cos(value)
print("Cosine of", value, "is", cosValue)

local logValue = Scalars:Log(value)
print("Natural Logarithm of", value, "is", logValue)
```

#### ZmodP
```lua
local Scalars = require path.to.Scalars

local ZmodP = Scalars.ZmodP
local number1 = ZmodP:new(42, 97)
local number2 = ZmodP:new(58, 97)

local sum = number1:Add(number2)
local difference = number1:Subtract(number2)
local product = number1:Multiply(number2)
local power = number1:Exponential(5)
local inverse = number1:Inverse()
```

## Primes
The primes lib covers functionalities ranging from basic prime testing to more complex tasks such as prime decomposition and factorization. With this, you can dynamically generate prime lists, determine the nth prime, decompose a number into its prime components, and also identify twin primes.

### Usage:

#### Require the module
```lua
local Primes = require path.to.Primes
```
#### Build a prime list up to 100
```lua
local primeList = Primes:BuildPrimesList(100)
```

#### Check if a number is a prime number
```lua
local isPrime = Primes:IsPrime(17)
print("Is 17 prime?", isPrime) 
```

#### Generate the next prime after the largest prime in the current list
```lua
local nextPrime = Primes:GenerateNextPrime()
```

#### Decompose a number, say 84, into its prime components
```lua
local primeDecomposition = Primes:Decompose(84)
print("Prime Decomposition of 84:", table.concat(primeDecomposition, ", "))
```

#### Retrieve the Nth prime
```lua
local tenthPrime = Primes:GetNthPrime(10)
```

#### Prime factorization of a number
```lua
local factorization = Primes:PrimeFactorization(60)
for prime, count in pairs(factorization) do
    print("Prime:", prime, "Count:", count)
end
```

#### Count the number of primes less than or equal to a number
```lua
local primeCount = Primes:PrimeCount(100)
print("Number of primes <= 100:", primeCount)
```

#### Check if a number, say 17, is a twin prime
```lua
local isTwin = Primes:IsTwinPrime(17)
print("Is 17 a twin prime?", isTwin)
```
