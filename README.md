# RES
✖️⚡ RES is Blazingly fast and abstracted Maths libraries container for roblox.

## MatrixOp
The MatrixOp library was created to provide comprehensive matrix operations in lua. The library allows for creation, manipulation, and calculations with matrices of various dimensions. The library covers matrix operations such as addition, subtraction, multiplication, transposition, LU decomposition, determinant calculation, and matrix inversion. 

### Usage:
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
graph:addEdge(1, 2, 10)
```

#### DFS: 
You can perform a DFS from a given start vertex.
```lua
graph:DFS(1)
```
#### Breadth First Search (BFS): 
You can perform a BFS from a given start vertex.
```lua
graph:BFS(1)
```

### Dijkstra's Algorithm: 
You can find the shortest paths from a given start vertex to all other vertices.
```lua
local distances, previous = graph:dijkstra(1)
```

#### Check if Graph is Connected: 
You can check if the graph is connected.
```lua
local isConnected = graph:isConnected()
```

#### Get Degree of Vertex: 
You can get the degree of a given vertex.
```lua
local degree = graph:getDegree(1)
```

#### Working with Adjacent Vertices: 
You can retrieve the adjacent vertices of a given vertex.
```lua
local adjacentVertices = graph:getAdjacentVertices(1)
```

## Scalars
I built the Scalars library to provide fast and efficient arithmetic operations on integers in a modular setting (ZmodP) and real-valued scalar functions. The library includes functionalities for addition, subtraction, multiplication, exponentiation, inverse in modular arithmetic, and general scalar operations like square root, sine, cosine, and natural logarithm.

### Usage:

#### General Functions
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

#### ZmodP
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

## StrMath
StrMath is a Lua operations library designed to facilitate fast and efficient arithmetic operations on large integers represented as strings. With StrMath, you can work with numbers that would otherwise exceed the conventional numeric limits in Lua. 

### Usage:

#### Integer Arithmetics
```lua
local num1 = StrMath.new("1234567890123456789012345678901234567890")
local num2 = StrMath.new("9876543210987654321098765432109876543210")

local sum = num1 + num2
local difference = num1 - num2
local product = num1 * num2
local quotient, remainder = num2 / num1

print("Sum:", sum)                   -- Sum: 11111111101111111101111111111111111111000
print("Difference:", difference)     -- Difference: -8641975310864197531086419753208641975320
print("Product:", product)           -- Product: 12193263111263526919239574329840067766267340827901332126249000
print("Quotient:", quotient, "Remainder:", remainder) -- Quotient, remainder would depend on the implementation
```

#### Negative Numbers
```lua
local num3 = StrMath.new("-1234567890123456789012345678901234567890")
local num4 = StrMath.new("-9876543210987654321098765432109876543210")

local sum_negative = num3 + num4
local product_negative = num3 * num4
local difference_negative = num3 - num4

print("Sum (Negative):", sum_negative)           -- Sum (Negative): -11111111101111111101111111111111111111000
print("Product (Negative):", product_negative)   -- Product (Negative): 12193263111263526919239574329840067766267340827901332126249000
print("Difference (Negative):", difference_negative) -- Difference (Negative): 8641975310864197531086419753208641975320
```

#### High precision arithmetics
```lua
local float1 = StrMath.new("1234.56789")
local float2 = StrMath.new("9876.54321")

local sum_float = float1 + float2
local product_float = float1 * float2
local quotient_float = float2 / float1

print("Sum (Float):", sum_float)             -- Sum (Float): 11111.1111
print("Product (Float):", product_float)     -- Product (Float): 12179491.9358695319
print("Quotient (Float):", quotient_float)   -- Quotient (Float): 7.980555953346855
```

#### Exponential
```lua
local base = StrMath.new("10")
local exponent = StrMath.new("20")

local power_result = base ^ exponent

print("Power:", power_result)                -- Power: 100000000000000000000
```

