# RES
✖️⚡ RES is Blazingly fast and abstracted Maths libraries container for roblox.

# StrMath
I've designed the StrMath library to allow for super quick arithmetic operations on large _integers_ represented as strings. This allows handling numbers that would otherwise exceed the typical numeric limits in Lua. I've provided functionalities for basic arithmetic such as addition, subtraction, multiplication, division, modulus, and exponentiation.

Usage:
```lua
local StrMath = require path.To.StrMath

local number1 = StrMath.new("31415926535897932384626433832795028841971693993751058209749445923078164062862089986280")
local number2 = StrMath.new("27182818284590452353602874713526624977572470936999595749669676277240766303535475945713")

local sum = number1 + number2
local product = number1 * number2
local difference = number1 - number2
local quotient = number1 / number2
local remainder = number1 % number2

print("Sum:", sum)            -- Output: Sum: 58598744820488384738229268546321653819544164930750653957419122200348930406408919972
print("Product:", product)    -- Output: Product: 8539734222673567065463550869546574495034888535765114961879601127067743044893204848617875072216249073013374895871952806582723184
print("Difference:", difference) -- Output: Difference: 42331382513174800431023590192684038762599230956815024588187847048406337253557137667
print("Quotient:", quotient) -- Output: Quotient: 1.15572734979092171709317072861359384154890420539925378682752234057380300685082454856
print("Remainder:", remainder) -- Output: Remainder: 42051808495118382020514540926987021367060802777631052526762208498189906616608558082
```

# MatrixOp
The MatrixOp library was created to provide comprehensive matrix operations in lua. The library allows for creation, manipulation, and calculations with matrices of various dimensions. The library covers matrix operations such as addition, subtraction, multiplication, transposition, LU decomposition, determinant calculation, and matrix inversion. 

Usage:
```lua
local Matrix = require path.to.Matrix

local matrixA = Matrix.new(3, 3, {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}})
local matrixB = Matrix.new(3, 3, {{9, 8, 7}, {6, 5, 4}, {3, 2, 1}})

local sum = matrixA + matrixB
local product = matrixA * matrixB
local transposeA = matrixA:transpose()
local determinantA = matrixA:determinant()
local inverseA = matrixA:inverse()

print("Sum:", sum)            -- Outputs a matrix representing the sum
print("Product:", product)    -- Outputs a matrix representing the product
print("Transpose:", transposeA) -- Outputs the transposed matrix
print("Determinant:", determinantA) -- Outputs the determinant of the matrix
print("Inverse:", inverseA)   -- Outputs the inverse of the matrix
```

# Graphs
I designed the Graphs library to allow for fast and efficient graph operations in Lua. It provides functionalities for creating and manipulating both directed and undirected graphs. The library supports common graph algorithms such as Depth First Search (DFS), Breadth First Search (BFS), Dijkstra's algorithm for shortest path, and some utility functions like checking connectivity and degree of a vertex.

Usage:

Creating a Graph:
```lua
local Graphs = require path.to.Graphs

local vertices = {1, 2, 3, 4, 5}
local edges = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 1}}

local graph = Graphs.Graph:new(vertices, edges)
```

Adding an edge:
You can add an edge between two vertices with an optional weight (default weight is 1).
```lua
graph:addEdge(1, 2, 10)
```

DFS
You can perform a DFS from a given start vertex.
```lua
graph:DFS(1)
```
Breadth First Search (BFS)
You can perform a BFS from a given start vertex.
```lua
graph:BFS(1)
```

Dijkstra's Algorithm
You can find the shortest paths from a given start vertex to all other vertices.
```lua
local distances, previous = graph:dijkstra(1)
```

Check if Graph is Connected
You can check if the graph is connected.
```lua
local isConnected = graph:isConnected()
```

Get Degree of Vertex
You can get the degree of a given vertex.
```lua
local degree = graph:getDegree(1)
```

Working with Adjacent Vertices
You can retrieve the adjacent vertices of a given vertex.
```lua
local adjacentVertices = graph:getAdjacentVertices(1)
```
# Scalars
I built the Scalars library to provide fast and efficient arithmetic operations on integers in a modular setting (ZmodP) and real-valued scalar functions. The library includes functionalities for addition, subtraction, multiplication, exponentiation, inverse in modular arithmetic, and general scalar operations like square root, sine, cosine, and natural logarithm.

Usage:

General Functions
```lua
local Scalars = require path.to.Scalars
local ScalarMaths = Scalars.ScalarMaths

local value = 25

local sqrtValue = ScalarMaths:sqrt(value)
print("Square Root of", value, "is", sqrtValue)

local sinValue = ScalarMaths:sin(value)
print("Sine of", value, "is", sinValue)

local cosValue = ScalarMaths:cos(value)
print("Cosine of", value, "is", cosValue)

local logValue = ScalarMaths:log(value)
print("Natural Logarithm of", value, "is", logValue)
```

ZmodP
```lua
local Scalars = require path.to.Scalars

local ZmodP = Scalars.ZmodP
local number1 = ZmodP:new(42, 97)
local number2 = ZmodP:new(58, 97)

local sum = number1:add(number2)
local difference = number1:subtract(number2)
local product = number1:multiply(number2)
local power = number1:exponential(5)
local inverse = number1:inverse()
```


