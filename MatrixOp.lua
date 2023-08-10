local Matrix = {}
Matrix.__index = Matrix

function Matrix.new(rowCount, colCount, initialValues)
  assert(type(rowCount) == "number" and rowCount > 0, "rowCount must be a positive integer")
  assert(type(colCount) == "number" and colCount > 0, "colCount must be a positive integer")
  
  local matrix = setmetatable({}, Matrix)
  matrix.rowCount = rowCount
  matrix.colCount = colCount
  matrix.data = initialValues or {}
  for row = 1, rowCount do
    matrix.data[row] = matrix.data[row] or {}
    for col = 1, colCount do
      matrix.data[row][col] = matrix.data[row][col] or 0
    end
  end
  
  return matrix
end

-- Additional utility function to initialize a matrix with zeros
local function zeroMatrix(rows, cols)
  local m = {}
  for i = 1, rows do
    m[i] = {}
    for j = 1, cols do
      m[i][j] = 0
    end
  end
  return m
end

function Matrix.__add(matrixA, matrixB)
  assert(matrixA.rowCount == matrixB.rowCount and matrixA.colCount == matrixB.colCount,
         "Matrices must have the same dimensions for addition.")

  local resultData = zeroMatrix(matrixA.rowCount, matrixA.colCount)
  for row = 1, matrixA.rowCount do
    for col = 1, matrixA.colCount do
      resultData[row][col] = matrixA.data[row][col] + matrixB.data[row][col]
    end
  end

  return Matrix.new(matrixA.rowCount, matrixA.colCount, resultData)
end

function Matrix.__mul(matrixA, matrixB)
  assert(matrixA.colCount == matrixB.rowCount,
         "Number of columns in the first matrix must equal the number of rows in the second matrix.")

  local resultData = {}
  for row = 1, matrixA.rowCount do
    resultData[row] = {}
    for col = 1, matrixB.colCount do
      local sum = 0
      for k = 1, matrixA.colCount do
        sum = sum + matrixA.data[row][k] * matrixB.data[k][col]
      end
      resultData[row][col] = sum
    end
  end

  return Matrix.new(matrixA.rowCount, matrixB.colCount, resultData)
end

function Matrix:transpose()
    local transposedData = {}
    for col = 1, self.colCount do
      transposedData[col] = {}
      for row = 1, self.rowCount do
        transposedData[col][row] = self.data[row][col]
      end
    end
    return Matrix.new(self.colCount, self.rowCount, transposedData)
  end


function Matrix:luDecomposition()
    assert(self.rowCount == self.colCount, "LU Decomposition requires a square matrix.")
    local n = self.rowCount
    local L = Matrix.new(n, n)
    local U = self:clone()

    for i = 1, n do
      L.data[i][i] = 1
      for j = i + 1, n do
        local factor = U.data[j][i] / U.data[i][i]
        L.data[j][i] = factor
        for k = i, n do
          U.data[j][k] = U.data[j][k] - factor * U.data[i][k]
        end
      end
    end

    return L, U
  end

function Matrix:determinant()
    assert(self.rowCount == self.colCount, "Determinant requires a square matrix.")
    local _, U = self:luDecomposition()
    local det = 1
    for i = 1, self.rowCount do
      det = det * U.data[i][i]
    end
    return det
end

function Matrix:inverse()
    assert(self.rowCount == self.colCount, "Inverse requires a square matrix.")
    local L, U = self:luDecomposition()
    local n = self.rowCount
    local inv = Matrix.new(n, n)

    for col = 1, n do
      local y = {0}
      y[col] = 1
      for i = 1, n do
        for j = 1, i - 1 do
          y[i] = y[i] - L.data[i][j] * y[j]
        end
        y[i] = y[i] / L.data[i][i]
      end

      for i = n, 1, -1 do
        for j = i + 1, n do
          y[i] = y[i] - U.data[i][j] * inv.data[j][col]
        end
        inv.data[i][col] = y[i] / U.data[i][i]
      end
    end

    return inv
  end

function Matrix:clone()
    local cloneData = {}
    for row = 1, self.rowCount do
      cloneData[row] = {}
      for col = 1, self.colCount do
        cloneData[row][col] = self.data[row][col]
      end
    end
    return Matrix.new(self.rowCount, self.colCount, cloneData)
end

return Matrix
