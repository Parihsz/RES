local Graphs = {}

Graphs.Graph = {
	vertices = {},       -- List of vertices
	adjacencyList = {},  -- Adjacency list representation
}

local Graph = Graphs.Graph

function Graph:new(vertices, edges)
	local o = {
		vertices = vertices or {},
		adjacencyList = {},
	}
	setmetatable(o, self)
	self.__index = self

	for i = 1, #vertices do
		o.adjacencyList[vertices[i]] = {}
	end

	for i = 1, #edges do
		o:addEdge(edges[i][1], edges[i][2], edges[i][3])
	end

	return o
end

function Graph:AddEdge(v1, v2, weight)
	weight = weight or 1
	table.insert(self.adjacencyList[v1], {vertex = v2, weight = weight})
	table.insert(self.adjacencyList[v2], {vertex = v1, weight = weight})
end

function Graph:GetAdjacentVertices(v)
	return self.adjacencyList[v]
end

function Graph:DFS(startVertex, visited)
	visited = visited or {}
	visited[startVertex] = true

	local adjVertices = self.adjacencyList[startVertex]
	for i = 1, #adjVertices do
		local adj = adjVertices[i]
		if not visited[adj.vertex] then
			self:DFS(adj.vertex, visited)
		end
	end
end

function Graph:BFS(startVertex)
	local visited = {}
	local queue = {startVertex}
	visited[startVertex] = true
	while #queue > 0 do
		local vertex = table.remove(queue, 1)
		local adjVertices = self.adjacencyList[vertex]
		for i = 1, #adjVertices do
			local adj = adjVertices[i]
			if not visited[adj.vertex] then
				visited[adj.vertex] = true
				table.insert(queue, adj.vertex)
			end
		end
	end
end

function Graph:Dijkstra(startVertex)
	local distances = {}
	local previous = {}
	local unvisited = {}

	for i = 1, #self.vertices do
		local vertex = self.vertices[i]
		distances[vertex] = math.huge
		unvisited[vertex] = true
	end

	distances[startVertex] = 0

	local current
	while current do
		local minDist = math.huge
		current = nil
		for vertex, _ in next, unvisited do
			if distances[vertex] and distances[vertex] < minDist then
				current = vertex
				minDist = distances[vertex]
			end
		end
		if not current then break end
		unvisited[current] = nil

		local adjVertices = self.adjacencyList[current]
		for i = 1, #adjVertices do
			local adj = adjVertices[i]
			local alt = distances[current] + adj.weight
			if alt < distances[adj.vertex] then
				distances[adj.vertex] = alt
				previous[adj.vertex] = current
			end
		end
	end

	return distances, previous
end

function Graph:isConnected()
	local visited = {}
	self:DFS(self.vertices[1], visited)
	for i = 1, #self.vertices do
		if not visited[self.vertices[i]] then
			return false
		end
	end
	return true
end

function Graph:GetDegree(vertex)
	return #self.adjacencyList[vertex]
end

return Graphs
