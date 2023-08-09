local StrMath = {
    functions = {}
}

local mt = {}

-- Helper Functions Dictionary
local helpers = {}

-- Utility: Reverse a string
function helpers.reverseString(s)
    return s:reverse()
end

-- Utility: Validate a string number
function helpers.validateNumber(str)
    if not str:match("^-?%d+$") then
        error("Invalid number string: " .. str)
    end
end

-- Utility: Add a single digit to a string
function helpers.addSingleDigit(str, digit)
    local carry = tonumber(digit)
    local result = {}

    for i = #str, 1, -1 do
        local sum = tonumber(str:sub(i, i)) + carry
        carry = math.floor(sum / 10)
        result[i] = sum % 10
    end

    if carry > 0 then
        table.insert(result, 1, carry)
    end

    return table.concat(result)
end

-- Utility: Double a string number
function helpers.addSelf(str)
    local carry = 0
    local result = {}

    for i = #str, 1, -1 do
        local sum = tonumber(str:sub(i, i)) * 2 + carry
        carry = math.floor(sum / 10)
        result[i] = sum % 10
    end

    if carry > 0 then
        table.insert(result, 1, carry)
    end

    return table.concat(result)
end

-- Utility: Generic addition
function helpers.genericAddition(str1, str2)
    if #str1 < #str2 then
        str1, str2 = str2, str1
    end

    str2 = str2 .. string.rep("0", #str1 - #str2)
    local carry = 0
    local result = {}

    for i = #str1, 1, -1 do
        local sum = tonumber(str1:sub(i, i)) + tonumber(str2:sub(i, i)) + carry
        carry = math.floor(sum / 10)
        result[i] = sum % 10
    end

    if carry > 0 then
        table.insert(result, 1, carry)
    end

    return table.concat(result)
end

-- Utility: Subtract string numbers
function helpers.subtractStrings(str1, str2)
    -- Validate if str1 is greater than str2
    if helpers.compareStrings(str1, str2) < 0 then
        error("First string must be larger for subtraction")
    end

    local result = {}
    local borrow = 0

    for i = #str1, 1, -1 do
        local subtrahend = tonumber(str2:sub(i, i) or 0) + borrow
        local minuend = tonumber(str1:sub(i, i))
        borrow = 0

        if minuend < subtrahend then
            borrow = 1
            minuend = minuend + 10
        end

        result[i] = minuend - subtrahend
    end

    local finalResult = table.concat(result):match("^0*(%d+)$") or "0"
    return finalResult
end

-- Utility: Multiply string by a digit
function helpers.multiplyStringByDigit(str, digit)
    local carry = 0
    local result = {}

    for i = #str, 1, -1 do
        local product = tonumber(str:sub(i, i)) * digit + carry
        carry = math.floor(product / 10)
        result[i] = product % 10
    end

    if carry > 0 then
        table.insert(result, 1, carry)
    end

    return table.concat(result)
end

-- Utility: Multiply two string numbers
function helpers.multiplyStrings(str1, str2)
    local result = "0"

    for i = #str2, 1, -1 do
        local digit = tonumber(str2:sub(i, i))
        local partialProduct = helpers.multiplyStringByDigit(str1, digit)
        partialProduct = partialProduct .. string.rep("0", #str2 - i)
        result = helpers.genericAddition(result, partialProduct)
    end

    return result
end

-- Utility: Zero Multiplication
function helpers.zeroMultiplication(str1, str2)
    return (str1 == "0" or str2 == "0") and "0" or false
end

-- Utility: Karatsuba multiplication
function helpers.karatsubaMultiplication(str1, str2)
    if #str1 < 10 or #str2 < 10 then
        return helpers.multiplyStrings(str1, str2)
    end

    local m = math.max(#str1, #str2)
    local m2 = math.floor(m / 2)

    local high1 = str1:sub(1, #str1 - m2)
    local low1 = str1:sub(#str1 - m2 + 1)

    local high2 = str2:sub(1, #str2 - m2)
    local low2 = str2:sub(#str2 - m2 + 1)

    local z0 = helpers.karatsubaMultiplication(low1, low2)
    local z1 = helpers.karatsubaMultiplication(helpers.genericAddition(low1, high1), helpers.genericAddition(low2, high2))
    local z2 = helpers.karatsubaMultiplication(high1, high2)

    return helpers.genericAddition(helpers.genericAddition(z2 .. string.rep("0", 2 * m2), helpers.subtractStrings(helpers.subtractStrings(z1, z2), z0) .. string.rep("0", m2)), z0)
end

-- Utility: Divide two string numbers
function helpers.divideStrings(str1, str2)
    if str2 == "0" then
        error("Division by zero error!")
    end

    local dividend = str1
    local divisor = str2
    local quotient = "0"

    while helpers.compareStrings(dividend, divisor) >= 0 do
        local partialQuotient = "1"
        local partialProduct = divisor

        while helpers.compareStrings(dividend, helpers.multiplyStrings(partialProduct, "2")) >= 0 do
            partialQuotient = helpers.multiplyStrings(partialQuotient, "2")
            partialProduct = helpers.multiplyStrings(partialProduct, "2")
        end

        quotient = helpers.genericAddition(quotient, partialQuotient)
        dividend = helpers.subtractStrings(dividend, partialProduct)
    end

    return quotient
end

-- Utility: Compare two string numbers
function helpers.compareStrings(str1, str2)
    local len1, len2 = #str1, #str2

    if len1 > len2 then
        return 1
    elseif len1 < len2 then
        return -1
    else
        for i = 1, len1 do
            local digit1, digit2 = tonumber(str1:sub(i, i)), tonumber(str2:sub(i, i))

            if digit1 > digit2 then
                return 1
            elseif digit1 < digit2 then
                return -1
            end
        end

        return 0
    end
end

-- Utility: Modulus two string numbers
function helpers.modulusStrings(str1, str2)
    if str2 == "0" then
        error("Modulus by zero error!")
    end

    local dividend = str1
    local divisor = str2

    while helpers.compareStrings(dividend, divisor) >= 0 do
        local partialQuotient = "1"
        local partialProduct = divisor

        while helpers.compareStrings(dividend, helpers.multiplyStrings(partialProduct, "2")) >= 0 do
            partialQuotient = helpers.multiplyStrings(partialQuotient, "2")
            partialProduct = helpers.multiplyStrings(partialProduct, "2")
        end

        dividend = helpers.subtractStrings(dividend, partialProduct)
    end

    return dividend
end

-- Power Operation
function helpers.powerStrings(base, exponent)
    if exponent == "0" then
        return "1"
    elseif base == "0" then
        return "0"
    else
        local result = "1"
        for _ = 1, tonumber(exponent) do
            result = helpers.multiplyStrings(result, base)
        end
        return result
    end
end

-- Special Cases Dictionary
local specialCases = {
    addSingleDigit = function(str1, str2)
        return #str2 == 1 and helpers.addSingleDigit(str1, str2) or false
    end,
    addSelf = function(str1, str2)
        return str1 == str2 and helpers.addSelf(str1) or false
    end,
    zeroAddition = function(str1, str2)
        return (str1 == "0" and str2) or (str2 == "0" and str1) or false
    end,
    zeroMultiplication = function(str1, str2)
        return (str1 == "0" or str2 == "0") and "0" or false
    end,
    zeroDivision = function(str1, str2)
        return str2 == "0" and "NaN" or false
    end,
    zeroSubtraction = function(str1, str2)
        return str1 == str2 and "0" or false
    end,
}

function StrMath.functions.addStrings(str1, str2)
    for _, specialCase in pairs(specialCases) do
        local result = specialCase(str1, str2)
        if result then
            return result
        end
    end
    return helpers.genericAddition(str1, str2)
end

function StrMath.functions.subtractStrings(str1, str2)
    local result = specialCases.zeroSubtraction(str1, str2)
    if result then
        return result
    end
    return helpers.subtractStrings(str1, str2)
end

function StrMath.functions.multiplyStrings(str1, str2)
    helpers.validateNumber(str1)
    helpers.validateNumber(str2)

    local result = specialCases.zeroMultiplication(str1, str2)
    if result then
        return result
    end

    local sign1, sign2 = 1, 1
    if str1:sub(1, 1) == "-" then
        str1 = str1:sub(2)
        sign1 = -1
    end
    if str2:sub(1, 1) == "-" then
        str2 = str2:sub(2)
        sign2 = -1
    end

    for _, specialCase in pairs(specialCases) do
        local result = specialCase(str1, str2)
        if result then
            return result
        end
    end

    local result = helpers.karatsubaMultiplication(str1, str2)
    if sign1 * sign2 < 0 then
        result = "-" .. result
    end
    return result
end

function StrMath.functions.divideStrings(str1, str2)
    local result = specialCases.zeroDivision(str1, str2)
    if result then
        return result
    end

    if str2 == "0" then
        return nil, "Division by zero" -- Handle division by zero
    end
    return helpers.divideStrings(str1, str2)
end

function StrMath.new(valueString)
    local instance = { valueString = valueString }
    return setmetatable(instance, mt)
end

function StrMath.functions.subtractStrings(str1, str2)
    return helpers.subtractStrings(str1, str2)
end

function StrMath.functions.multiplyStrings(str1, str2)
    return helpers.multiplyStrings(str1, str2)
end

function StrMath.functions.divideStrings(str1, str2)
    if str2 == "0" then
        return nil, "Division by zero" -- Handle division by zero
    end
    return helpers.divideStrings(str1, str2)
end

function StrMath.functions.modulusStrings(str1, str2)
    return helpers.modulusStrings(str1, str2)
end

function StrMath.functions.powerStrings(base, exponent)
    return helpers.powerStrings(base, exponent)
end

function mt.__add(number1, number2)
    return StrMath.new(StrMath.functions.addStrings(number1.valueString, number2.valueString))
end

function mt.__sub(number1, number2)
    return StrMath.new(StrMath.functions.subtractStrings(number1.valueString, number2.valueString))
end

function mt.__mul(number1, number2)
    return StrMath.new(StrMath.functions.multiplyStrings(number1.valueString, number2.valueString))
end

function mt.__div(number1, number2)
    local result, err = StrMath.functions.divideStrings(number1.valueString, number2.valueString)
    if err then
        error(err) 
    end
    return StrMath.new(result)
end

function mt.__mod(number1, number2)
    return StrMath.new(StrMath.functions.modulusStrings(number1.valueString, number2.valueString))
end

function mt.__pow(base, exponent)
    return StrMath.new(StrMath.functions.powerStrings(base.valueString, exponent.valueString))
end

function mt.__tostring(number)
    return number.valueString
end
mt.__index = StrMath
mt.__metatable = "protected"

return StrMath
