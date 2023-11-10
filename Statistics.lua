local Statistics = {}

local function isTableOfNumbers(t)
    for _, v in t do
        if type(v) ~= "number" then
            return false
        end
    end
    return true
end

local function sortData(data)
    assert(isTableOfNumbers(data), "Data must be a table of numbers")
    table.sort(data)
    return data
end

local function percentile(data, p)
    assert(type(p) == "number" and p >= 0 and p <= 100, "Percentile must be a number between 0 and 100")
    local sortedData = sortData(data)
    local k = (p / 100) * (#sortedData - 1) + 1
    local f = math.floor(k)
    local c = math.ceil(k)
    if f == c then
        return sortedData[f]
    else
        return sortedData[f] + (k - f) * (sortedData[c] - sortedData[f])
    end
end

function Statistics.Mean(data)
    assert(isTableOfNumbers(data), "Data must be a table of numbers")
    local sum = 0
    for _, value in ipairs(data) do
        sum = sum + value
    end
    return sum / #data
end

function Statistics.Median(data)
    return percentile(data, 50)
end

function Statistics.Quartile(data, q)
    assert(q == 1 or q == 2 or q == 3, "Quartile must be 1, 2, or 3")
    return percentile(data, q * 25)
end

function Statistics.Decile(data, d)
    assert(type(d) == "number" and d >= 1 and d <= 9, "Decile must be an integer between 1 and 9")
    return percentile(data, d * 10)
end

function Statistics.Variance(data)
    assert(isTableOfNumbers(data) and #data > 1, "Data must be a table of numbers with at least two elements")
    local mean = Statistics.Mean(data)
    local sum = 0
    for _, value in ipairs(data) do
        sum = sum + (value - mean)^2
    end
    return sum / (#data - 1)
end

function Statistics.StandardDeviation(data)
    return math.sqrt(Statistics.Variance(data))
end

function Statistics.Range(data)
    local sortedData = sortData(data)
    return sortedData[#sortedData] - sortedData[1]
end

function Statistics.ZScore(data, value)
    assert(isTableOfNumbers(data), "Data must be a table of numbers")
    assert(type(value) == "number", "Value must be a number")
    local mean = Statistics.Mean(data)
    local standardDeviation = Statistics.StandardDeviation(data)
    return (value - mean) / standardDeviation
end

return Statistics
