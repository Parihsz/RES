local StrMath = {
    functions = {}
}

local mt = {}

-- Helper Functions Dictionary
local helpers = {}

function helpers.reverseString(s)
    return s:reverse()
end

function helpers.rjust(str, length, char)
    char = char or "0"
    return string.rep(char, length - #str) .. str
end

function helpers.validateNumber(str)
    if not str:match("^-?%d+%.?%d*$") then
        error("Invalid number string: " .. str)
    end
end

function helpers.splitNumber(str)
    local integerPart, fractionalPart = str:match("^(-?%d+)(%.%d*)$")
    fractionalPart = fractionalPart or ""
    fractionalPart = fractionalPart:sub(2) -- remove the dot
    return integerPart, fractionalPart
end

function helpers.addStrings(str1, str2)
    local integer1, fraction1 = helpers.splitNumber(str1)
    local integer2, fraction2 = helpers.splitNumber(str2)

    local sumFraction = helpers.addStringsOnlyIntegers(fraction1, fraction2)
    local overflow = math.floor(sumFraction / (10 ^ #fraction1))
    sumFraction = sumFraction % (10 ^ #fraction1)

    local sumInteger = helpers.addStringsOnlyIntegers(integer1, integer2) + overflow

    return sumInteger .. (sumFraction ~= 0 and ("." .. sumFraction) or "")
end

function helpers.genericAddition(str1, str2)
    if str1:sub(1, 1) == "-" and str2:sub(1, 1) ~= "-" then
        return helpers.subtractStrings(str2, str1:sub(2))
    elseif str1:sub(1, 1) ~= "-" and str2:sub(1, 1) == "-" then
        return helpers.subtractStrings(str1, str2:sub(2))
    elseif str1:sub(1, 1) == "-" and str2:sub(1, 1) == "-" then
        return "-" .. helpers.addStrings(str1:sub(2), str2:sub(2))
    else
        return helpers.addStrings(str1, str2)
    end
end

function helpers.addStringsOnlyIntegers(str1, str2)
    local length = math.max(#str1, #str2)
    str1 = str1:rjust(length, "0")
    str2 = str2:rjust(length, "0")

    local result = {}
    local carry = 0

    for i = length, 1, -1 do
        local sum = tonumber(str1:sub(i, i)) + tonumber(str2:sub(i, i)) + carry
        carry = math.floor(sum / 10)
        result[i] = sum % 10
    end

    if carry > 0 then
        table.insert(result, 1, carry)
    end

    return table.concat(result)
end

function helpers.subtractStrings(str1, str2)
    local integer1, fraction1 = helpers.splitNumber(str1)
    local integer2, fraction2 = helpers.splitNumber(str2)

    if #fraction2 > #fraction1 then
        fraction1 = fraction1 .. string.rep("0", #fraction2 - #fraction1)
    elseif #fraction1 > #fraction2 then
        fraction2 = fraction2 .. string.rep("0", #fraction1 - #fraction2)
    end

    local subFraction = helpers.subtractStringsOnlyIntegers(fraction1, fraction2)
    local borrow = 0

    if subFraction < 0 then
        subFraction = subFraction + (10 ^ #fraction1)
        borrow = 1
    end

    local subInteger = helpers.subtractStringsOnlyIntegers(integer1, integer2) - borrow

    return subInteger .. (subFraction ~= 0 and ("." .. subFraction) or "")
end

function helpers.subtractStringsOnlyIntegers(str1, str2)
    local length = math.max(#str1, #str2)
    str1 = helpers.rjust(str1, length, "0")
    str2 = helpers.rjust(str2, length, "0")    

    local result = {}
    local borrow = 0

    for i = length, 1, -1 do
        local minuend = tonumber(str1:sub(i, i)) - borrow
        local subtrahend = tonumber(str2:sub(i, i))
        borrow = 0

        if minuend < subtrahend then
            borrow = 1
            minuend = minuend + 10
        end

        result[i] = minuend - subtrahend
    end

    local finalResult = table.concat(result):match("^0*(%d+)$") or "0"
    return tonumber(finalResult)
end

function helpers.multiplyStrings(str1, str2)
    local integer1, fraction1 = helpers.splitNumber(str1)
    local integer2, fraction2 = helpers.splitNumber(str2)

    local productInteger = helpers.multiplyStringsOnlyIntegers(integer1, integer2)
    local productFraction1 = helpers.multiplyStringsOnlyIntegers(integer1, fraction2)
    local productFraction2 = helpers.multiplyStringsOnlyIntegers(integer2, fraction1)
    local productFraction3 = helpers.multiplyStringsOnlyIntegers(fraction1, fraction2)

    local fractionalLength = #fraction1 + #fraction2
    local productFraction = helpers.addStringsOnlyIntegers(productFraction1 .. productFraction2, productFraction3)

    local overflow = math.floor(productFraction / (10 ^ fractionalLength))
    productFraction = productFraction % (10 ^ fractionalLength)

    productInteger = helpers.addStringsOnlyIntegers(productInteger, tostring(overflow))

    return productInteger .. (productFraction ~= 0 and ("." .. productFraction) or "")
end

function helpers.multiplyStringsOnlyIntegers(str1, str2)
    str1 = helpers.rjust(str1, #str2, "0")
    str2 = helpers.rjust(str2, #str1, "0")

    local result = "0"

    for i = #str2, 1, -1 do
        local digit2 = tonumber(str2:sub(i, i))
        local partialProduct = helpers.multiplyStringByDigit(str1, digit2)
        result = helpers.addStringsOnlyIntegers(result, partialProduct .. string.rep("0", #str2 - i))
    end

    return result
end

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


function helpers.zeroMultiplication(str1, str2)
    return (str1 == "0" or str2 == "0") and "0" or false
end

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

    return helpers.addStrings(helpers.addStrings(z2 .. string.rep("0", 2 * m2), helpers.subtractStrings(helpers.subtractStrings(z1, z2), z0) .. string.rep("0", m2)), z0)
end

function helpers.divideStrings(str1, str2)
    if str2 == "0" then
        error("Division by zero error!")
    end

    local sign = ""
    if str1:sub(1, 1) == "-" then
        sign = sign == "" and "-" or ""
        str1 = str1:sub(2)
    end
    if str2:sub(1, 1) == "-" then
        sign = sign == "" and "-" or ""
        str2 = str2:sub(2)
    end

    local quotient = ""
    local remainder = ""
    local current = ""

    for i = 1, #str1 do
        current = current .. str1:sub(i, i)
        local digit = 0

        while helpers.compareStrings(current, str2) >= 0 do
            current = helpers.subtractStringsOnlyIntegers(current, str2)
            digit = digit + 1
        end

        remainder = current
        quotient = quotient .. tostring(digit)
    end

    quotient = quotient:match("^0*(%d+)$") or "0"
    remainder = remainder:match("^0*(%d+)$") or "0"

    return sign .. quotient --, remainder
end

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
    for _, specialCase in specialCases do
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

    for _, specialCase in specialCases do
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

function StrMath.functions.compareStrings(str1, str2)
    return helpers.compareStrings(str1, str2)
end

function StrMath:__add(other)
    return StrMath.new(StrMath.functions.addStrings(self.valueString, other.valueString))
end

function StrMath:__sub(other)
    return StrMath.new(StrMath.functions.subtractStrings(self.valueString, other.valueString))
end

function StrMath:__mul(other)
    return StrMath.new(StrMath.functions.multiplyStrings(self.valueString, other.valueString))
end

function StrMath:__div(other)
    return StrMath.new(StrMath.functions.divideStrings(self.valueString, other.valueString))
end

function StrMath:__mod(other)
    return StrMath.new(StrMath.functions.modulusStrings(self.valueString, other.valueString))
end

function StrMath:__pow(other)
    return StrMath.new(StrMath.functions.powerStrings(self.valueString, other.valueString))
end

function StrMath:__eq(other)
    return self.valueString == other.valueString
end

function StrMath:__lt(other)
    return StrMath.functions.compareStrings(self.valueString, other.valueString) < 0
end

function StrMath:__le(other)
    return StrMath.functions.compareStrings(self.valueString, other.valueString) <= 0
end

function StrMath:__tostring()
    return self.valueString
end

mt.__index = StrMath
mt.__add = StrMath.__add
mt.__sub = StrMath.__sub
mt.__mul = StrMath.__mul
mt.__div = StrMath.__div
mt.__mod = StrMath.__mod
mt.__pow = StrMath.__pow
mt.__eq = StrMath.__eq
mt.__lt = StrMath.__lt
mt.__le = StrMath.__le
mt.__tostring = StrMath.__tostring


mt.__index = StrMath
mt.__metatable = "protected"

return StrMath
