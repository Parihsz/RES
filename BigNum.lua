local BigNum = {
    functions = {}
}

local mt = {}

-- Helper Functions Dictionary
local helpers = {}

function helpers.ReverseString(s)
    return s:Reverse()
end

function helpers.RJust(str, length, char)
    char = char or "0"
    return string.rep(char, length - #str) .. str
end

function helpers.ValidateNumber(str)
    if not str:match("^-?%d+%.?%d*$") then
        error("Invalid number string: " .. str)
    end
end

function helpers.SplitNumber(str)
    local integerPart, fractionalPart = str:match("^(-?%d+)(%.%d*)$")
    fractionalPart = fractionalPart or ""
    fractionalPart = fractionalPart:sub(2) -- remove the dot
    return integerPart, fractionalPart
end

function helpers.AddStrings(str1, str2)
    local integer1, fraction1 = helpers.SplitNumber(str1)
    local integer2, fraction2 = helpers.SplitNumber(str2)

    local sumFraction = helpers.AddStringsOnlyIntegers(fraction1, fraction2)
    local overflow = math.floor(sumFraction / (10 ^ #fraction1))
    sumFraction = sumFraction % (10 ^ #fraction1)

    local sumInteger = helpers.AddStringsOnlyIntegers(integer1, integer2) + overflow

    return sumInteger .. (sumFraction ~= 0 and ("." .. sumFraction) or "")
end

function helpers.genericAddition(str1, str2)
    if str1:sub(1, 1) == "-" and str2:sub(1, 1) ~= "-" then
        return helpers.SubtractStrings(str2, str1:sub(2))
    elseif str1:sub(1, 1) ~= "-" and str2:sub(1, 1) == "-" then
        return helpers.SubtractStrings(str1, str2:sub(2))
    elseif str1:sub(1, 1) == "-" and str2:sub(1, 1) == "-" then
        return "-" .. helpers.AddStrings(str1:sub(2), str2:sub(2))
    else
        return helpers.AddStrings(str1, str2)
    end
end

function helpers.AddStringsOnlyIntegers(str1, str2)
    local length = math.max(#str1, #str2)
    str1 = str1:RJust(length, "0")
    str2 = str2:RJust(length, "0")

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

function helpers.SubtractStrings(str1, str2)
    local integer1, fraction1 = helpers.SplitNumber(str1)
    local integer2, fraction2 = helpers.SplitNumber(str2)

    if #fraction2 > #fraction1 then
        fraction1 = fraction1 .. string.rep("0", #fraction2 - #fraction1)
    elseif #fraction1 > #fraction2 then
        fraction2 = fraction2 .. string.rep("0", #fraction1 - #fraction2)
    end

    local subFraction = helpers.SubtractStringsOnlyIntegers(fraction1, fraction2)
    local borrow = 0

    if subFraction < 0 then
        subFraction = subFraction + (10 ^ #fraction1)
        borrow = 1
    end

    local subInteger = helpers.SubtractStringsOnlyIntegers(integer1, integer2) - borrow

    return subInteger .. (subFraction ~= 0 and ("." .. subFraction) or "")
end

function helpers.SubtractStringsOnlyIntegers(str1, str2)
    local length = math.max(#str1, #str2)
    str1 = helpers.RJust(str1, length, "0")
    str2 = helpers.RJust(str2, length, "0")    

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

function helpers.MultiplyStrings(str1, str2)
    local integer1, fraction1 = helpers.SplitNumber(str1)
    local integer2, fraction2 = helpers.SplitNumber(str2)

    local productInteger = helpers.MultiplyStringsOnlyIntegers(integer1, integer2)
    local productFraction1 = helpers.MultiplyStringsOnlyIntegers(integer1, fraction2)
    local productFraction2 = helpers.MultiplyStringsOnlyIntegers(integer2, fraction1)
    local productFraction3 = helpers.MultiplyStringsOnlyIntegers(fraction1, fraction2)

    local fractionalLength = #fraction1 + #fraction2
    local productFraction = helpers.AddStringsOnlyIntegers(productFraction1 .. productFraction2, productFraction3)

    local overflow = math.floor(productFraction / (10 ^ fractionalLength))
    productFraction = productFraction % (10 ^ fractionalLength)

    productInteger = helpers.AddStringsOnlyIntegers(productInteger, tostring(overflow))

    return productInteger .. (productFraction ~= 0 and ("." .. productFraction) or "")
end

function helpers.MultiplyStringsOnlyIntegers(str1, str2)
    str1 = helpers.RJust(str1, #str2, "0")
    str2 = helpers.RJust(str2, #str1, "0")

    local result = "0"

    for i = #str2, 1, -1 do
        local digit2 = tonumber(str2:sub(i, i))
        local partialProduct = helpers.MultiplyStringByDigit(str1, digit2)
        result = helpers.AddStringsOnlyIntegers(result, partialProduct .. string.rep("0", #str2 - i))
    end

    return result
end

function helpers.MultiplyStringByDigit(str, digit)
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


function helpers.ZeroMultiplication(str1, str2)
    return (str1 == "0" or str2 == "0") and "0" or false
end

function helpers.KaratsubaMultiplication(str1, str2)
    if #str1 < 10 or #str2 < 10 then
        return helpers.MultiplyStrings(str1, str2)
    end

    local m = math.max(#str1, #str2)
    local m2 = math.floor(m / 2)

    local high1 = str1:sub(1, #str1 - m2)
    local low1 = str1:sub(#str1 - m2 + 1)

    local high2 = str2:sub(1, #str2 - m2)
    local low2 = str2:sub(#str2 - m2 + 1)

    local z0 = helpers.KaratsubaMultiplication(low1, low2)
    local z1 = helpers.KaratsubaMultiplication(helpers.genericAddition(low1, high1), helpers.genericAddition(low2, high2))
    local z2 = helpers.KaratsubaMultiplication(high1, high2)

    return helpers.AddStrings(helpers.AddStrings(z2 .. string.rep("0", 2 * m2), helpers.SubtractStrings(helpers.SubtractStrings(z1, z2), z0) .. string.rep("0", m2)), z0)
end

function helpers.DivideStrings(str1, str2)
    if str2 == "0" then
        error("Division by Zero error!")
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

        while helpers.CompareStrings(current, str2) >= 0 do
            current = helpers.SubtractStringsOnlyIntegers(current, str2)
            digit = digit + 1
        end

        remainder = current
        quotient = quotient .. tostring(digit)
    end

    quotient = quotient:match("^0*(%d+)$") or "0"
    remainder = remainder:match("^0*(%d+)$") or "0"

    return sign .. quotient --, remainder
end

function helpers.CompareStrings(str1, str2)
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

function helpers.ModulusStrings(str1, str2)
    if str2 == "0" then
        error("Modulus by Zero error!")
    end

    local Dividend = str1
    local divisor = str2

    while helpers.CompareStrings(Dividend, divisor) >= 0 do
        local partialQuotient = "1"
        local partialProduct = divisor

        while helpers.CompareStrings(Dividend, helpers.MultiplyStrings(partialProduct, "2")) >= 0 do
            partialQuotient = helpers.MultiplyStrings(partialQuotient, "2")
            partialProduct = helpers.MultiplyStrings(partialProduct, "2")
        end

        Dividend = helpers.SubtractStrings(Dividend, partialProduct)
    end

    return Dividend
end

function helpers.PowerStrings(base, exponent)
    if exponent == "0" then
        return "1"
    elseif base == "0" then
        return "0"
    else
        local result = "1"
        for _ = 1, tonumber(exponent) do
            result = helpers.MultiplyStrings(result, base)
        end
        return result
    end
end

-- Special Cases Dictionary
local specialCases = {
    AddSingleDigit = function(str1, str2)
        return #str2 == 1 and helpers.AddSingleDigit(str1, str2) or false
    end,
    AddSelf = function(str1, str2)
        return str1 == str2 and helpers.AddSelf(str1) or false
    end,
    ZeroAddition = function(str1, str2)
        return (str1 == "0" and str2) or (str2 == "0" and str1) or false
    end,
    ZeroMultiplication = function(str1, str2)
        return (str1 == "0" or str2 == "0") and "0" or false
    end,
    ZeroDivision = function(str1, str2)
        return str2 == "0" and "NaN" or false
    end,
    ZeroSubtraction = function(str1, str2)
        return str1 == str2 and "0" or false
    end,
}

function BigNum.functions.AddStrings(str1, str2)
    for _, specialCase in specialCases do
        local result = specialCase(str1, str2)
        if result then
            return result
        end
    end
    return helpers.genericAddition(str1, str2)
end

function BigNum.functions.SubtractStrings(str1, str2)
    local result = specialCases.ZeroSubtraction(str1, str2)
    if result then
        return result
    end
    return helpers.SubtractStrings(str1, str2)
end

function BigNum.functions.MultiplyStrings(str1, str2)
    helpers.ValidateNumber(str1)
    helpers.ValidateNumber(str2)

    local result = specialCases.ZeroMultiplication(str1, str2)
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

    local result = helpers.KaratsubaMultiplication(str1, str2)
    if sign1 * sign2 < 0 then
        result = "-" .. result
    end
    return result
end

function BigNum.functions.DivideStrings(str1, str2)
    local result = specialCases.ZeroDivision(str1, str2)
    if result then
        return result
    end

    if str2 == "0" then
        return nil, "Division by Zero" -- Handle division by Zero
    end
    return helpers.DivideStrings(str1, str2)
end

function BigNum.new(valueString)
    local instance = { valueString = valueString }
    return setmetatable(instance, mt)
end

function BigNum.functions.SubtractStrings(str1, str2)
    return helpers.SubtractStrings(str1, str2)
end

function BigNum.functions.MultiplyStrings(str1, str2)
    return helpers.MultiplyStrings(str1, str2)
end

function BigNum.functions.DivideStrings(str1, str2)
    if str2 == "0" then
        return nil, "Division by Zero" -- Handle division by Zero
    end
    return helpers.DivideStrings(str1, str2)
end

function BigNum.functions.ModulusStrings(str1, str2)
    return helpers.ModulusStrings(str1, str2)
end

function BigNum.functions.PowerStrings(base, exponent)
    return helpers.PowerStrings(base, exponent)
end

function BigNum.functions.CompareStrings(str1, str2)
    return helpers.CompareStrings(str1, str2)
end

function BigNum:__add(other)
    return BigNum.new(BigNum.functions.AddStrings(self.valueString, other.valueString))
end

function BigNum:__sub(other)
    return BigNum.new(BigNum.functions.SubtractStrings(self.valueString, other.valueString))
end

function BigNum:__mul(other)
    return BigNum.new(BigNum.functions.MultiplyStrings(self.valueString, other.valueString))
end

function BigNum:__div(other)
    return BigNum.new(BigNum.functions.DivideStrings(self.valueString, other.valueString))
end

function BigNum:__mod(other)
    return BigNum.new(BigNum.functions.ModulusStrings(self.valueString, other.valueString))
end

function BigNum:__pow(other)
    return BigNum.new(BigNum.functions.PowerStrings(self.valueString, other.valueString))
end

function BigNum:__eq(other)
    return self.valueString == other.valueString
end

function BigNum:__lt(other)
    return BigNum.functions.CompareStrings(self.valueString, other.valueString) < 0
end

function BigNum:__le(other)
    return BigNum.functions.CompareStrings(self.valueString, other.valueString) <= 0
end

function BigNum:__tostring()
    return self.valueString
end

mt.__index = BigNum
mt.__Add = BigNum.__Add
mt.__sub = BigNum.__sub
mt.__mul = BigNum.__mul
mt.__div = BigNum.__div
mt.__mod = BigNum.__mod
mt.__pow = BigNum.__pow
mt.__eq = BigNum.__eq
mt.__lt = BigNum.__lt
mt.__le = BigNum.__le
mt.__tostring = BigNum.__tostring


mt.__index = BigNum
mt.__metatable = "protected"

return BigNum
