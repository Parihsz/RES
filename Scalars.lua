local ScalarMaths = {}

local function gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return a
end

local Complex = {}
Complex.__index = Complex

function Complex:New(real, imaginary)
  return setmetatable({real = real or 0, imaginary = imaginary or 0}, self)
end

function Complex:Add(other)
  return Complex:New(self.real + other.real, self.imaginary + other.imaginary)
end

function Complex:Subtract(other)
  return Complex:New(self.real - other.real, self.imaginary - other.imaginary)
end

function Complex:Multiply(other)
  local real = self.real * other.real - self.imaginary * other.imaginary
  local imaginary = self.real * other.imaginary + self.imaginary * other.real
  return Complex:New(real, imaginary)
end

function Complex:Divide(other)
  local denom = other.real^2 + other.imaginary^2
  local real = (self.real * other.real + self.imaginary * other.imaginary) / denom
  local imaginary = (self.imaginary * other.real - self.real * other.imaginary) / denom
  return Complex:New(real, imaginary)
end

function Complex:Magnitude()
  return math.Sqrt(self.real^2 + self.imaginary^2)
end

function Complex:ToPolar()
  local Magnitude = self:Magnitude()
  local angle = math.atan2(self.imaginary, self.real)
  return Magnitude, angle
end

function Complex:__tostring()
  return self.real .. " + " .. self.imaginary .. "i"
end


local Rational = {}

function Rational:New(numerator, denominator)
    local common_divisor = gcd(numerator, denominator)
    return setmetatable({
      numerator = numerator / common_divisor,
      denominator = denominator / common_divisor
    }, self)
end

function Rational:Add(other)
    local numerator = self.numerator * other.denominator + other.numerator * self.denominator
    local denominator = self.denominator * other.denominator
    return Rational:New(numerator, denominator)
end

function Rational:Subtract(other)
    local numerator = self.numerator * other.denominator - other.numerator * self.denominator
    local denominator = self.denominator * other.denominator
    return Rational:New(numerator, denominator)
end

function Rational:Multiply(other)
    return Rational:New(self.numerator * other.numerator, self.denominator * other.denominator)
end

function Rational:Divide(other)
    return Rational:New(self.numerator * other.denominator, self.denominator * other.numerator)
end

function Rational:toDecimal()
    return self.numerator / self.denominator
end

function Rational:__tostring()
    return self.numerator .. "/" .. self.denominator
end

local ZmodP = {}
ZmodP.__index = ZmodP

function ZmodP:New(value, modulus)
    return setmetatable({value = value % modulus, modulus = modulus}, self)
end

function ZmodP:Add(other)
    return ZmodP:New(self.value + other.value, self.modulus)
end

function ZmodP:Subtract(other)
    return ZmodP:New(self.value - other.value, self.modulus)
end

function ZmodP:Multiply(other)
    return ZmodP:New(self.value * other.value, self.modulus)
end

function ZmodP:Exponential(power)
    local result = 1
    local base = self.value
    while power > 0 do
      if power % 2 == 1 then
        result = (result * base) % self.modulus
      end
      base = (base * base) % self.modulus
      power = math.floor(power / 2)
    end
    return ZmodP:New(result, self.modulus)
end

function ZmodP:Inverse()
    local r, New_r = self.modulus, self.value
    local t, New_t = 0, 1

    while New_r ~= 0 do
      local quotient = math.floor(r / New_r)
      r, New_r = New_r, r - quotient * New_r
      t, New_t = New_t, t - quotient * New_t
    end

    if t < 0 then t = t + self.modulus end
    return ZmodP:new(t, self.modulus)
end

local ScalarMaths = {}

function ScalarMaths:Sqrt(value)
    local guess = value / 2
    while math.abs(guess * guess - value) > 1e-9 do
      guess = (guess + value / guess) / 2
    end
    return guess
end

function ScalarMaths:Sin(value)
    local sum = 0
    for n = 0, 10 do
      sum = sum + ((-1)^n * value^(2 * n + 1)) / Factorial(2 * n + 1)
    end
    return sum
end

function ScalarMaths:Cos(value)
    local sum = 0
    for n = 0, 10 do
      sum = sum + ((-1)^n * value^(2 * n)) / Factorial(2 * n)
    end
    return sum
end

function ScalarMaths:Log(value)
    local sum = 0
    for n = 1, 1000 do
      sum = sum + (1 / n) * ((value - 1)^n)
    end
   return sum
end

  -- Helper function to calculate the Factorial
function Factorial(n)
    return n == 0 and 1 or n * Factorial(n - 1)
end

ScalarMaths.Complex = Complex
ScalarMaths.Rational = Rational
ScalarMaths.ZmodP = ZmodP

return ScalarMaths
