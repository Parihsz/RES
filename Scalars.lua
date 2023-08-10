local ScalarMaths = {}

local function gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return a
end

local Complex = {}
Complex.__index = Complex

function Complex:new(real, imaginary)
  return setmetatable({real = real or 0, imaginary = imaginary or 0}, self)
end

function Complex:add(other)
  return Complex:new(self.real + other.real, self.imaginary + other.imaginary)
end

function Complex:subtract(other)
  return Complex:new(self.real - other.real, self.imaginary - other.imaginary)
end

function Complex:multiply(other)
  local real = self.real * other.real - self.imaginary * other.imaginary
  local imaginary = self.real * other.imaginary + self.imaginary * other.real
  return Complex:new(real, imaginary)
end

function Complex:divide(other)
  local denom = other.real^2 + other.imaginary^2
  local real = (self.real * other.real + self.imaginary * other.imaginary) / denom
  local imaginary = (self.imaginary * other.real - self.real * other.imaginary) / denom
  return Complex:new(real, imaginary)
end

function Complex:magnitude()
  return math.sqrt(self.real^2 + self.imaginary^2)
end

function Complex:toPolar()
  local magnitude = self:magnitude()
  local angle = math.atan2(self.imaginary, self.real)
  return magnitude, angle
end

function Complex:__tostring()
  return self.real .. " + " .. self.imaginary .. "i"
end


local Rational = {}

function Rational:new(numerator, denominator)
    local common_divisor = gcd(numerator, denominator)
    return setmetatable({
      numerator = numerator / common_divisor,
      denominator = denominator / common_divisor
    }, self)
end

function Rational:add(other)
    local numerator = self.numerator * other.denominator + other.numerator * self.denominator
    local denominator = self.denominator * other.denominator
    return Rational:new(numerator, denominator)
end

function Rational:subtract(other)
    local numerator = self.numerator * other.denominator - other.numerator * self.denominator
    local denominator = self.denominator * other.denominator
    return Rational:new(numerator, denominator)
end

function Rational:multiply(other)
    return Rational:new(self.numerator * other.numerator, self.denominator * other.denominator)
end

function Rational:divide(other)
    return Rational:new(self.numerator * other.denominator, self.denominator * other.numerator)
end

function Rational:toDecimal()
    return self.numerator / self.denominator
end

function Rational:__tostring()
    return self.numerator .. "/" .. self.denominator
end

local ZmodP = {}
ZmodP.__index = ZmodP

function ZmodP:new(value, modulus)
    return setmetatable({value = value % modulus, modulus = modulus}, self)
end

function ZmodP:add(other)
    return ZmodP:new(self.value + other.value, self.modulus)
end

function ZmodP:subtract(other)
    return ZmodP:new(self.value - other.value, self.modulus)
end

function ZmodP:multiply(other)
    return ZmodP:new(self.value * other.value, self.modulus)
end

function ZmodP:exponential(power)
    local result = 1
    local base = self.value
    while power > 0 do
      if power % 2 == 1 then
        result = (result * base) % self.modulus
      end
      base = (base * base) % self.modulus
      power = math.floor(power / 2)
    end
    return ZmodP:new(result, self.modulus)
end

function ZmodP:inverse()
    local r, new_r = self.modulus, self.value
    local t, new_t = 0, 1

    while new_r ~= 0 do
      local quotient = math.floor(r / new_r)
      r, new_r = new_r, r - quotient * new_r
      t, new_t = new_t, t - quotient * new_t
    end

    if t < 0 then t = t + self.modulus end
    return ZmodP:new(t, self.modulus)
end

local ScalarMaths = {}

function ScalarMaths:sqrt(value)
    local guess = value / 2
    while math.abs(guess * guess - value) > 1e-9 do
      guess = (guess + value / guess) / 2
    end
    return guess
end

function ScalarMaths:sin(value)
    local sum = 0
    for n = 0, 10 do
      sum = sum + ((-1)^n * value^(2 * n + 1)) / factorial(2 * n + 1)
    end
    return sum
end

function ScalarMaths:cos(value)
    local sum = 0
    for n = 0, 10 do
      sum = sum + ((-1)^n * value^(2 * n)) / factorial(2 * n)
    end
    return sum
end

function ScalarMaths:log(value)
    local sum = 0
    for n = 1, 1000 do
      sum = sum + (1 / n) * ((value - 1)^n)
    end
   return sum
end

  -- Helper function to calculate the factorial
function factorial(n)
    return n == 0 and 1 or n * factorial(n - 1)
end

ScalarMaths.Complex = Complex
ScalarMaths.Rational = Rational
ScalarMaths.ZmodP = ZmodP

return ScalarMaths
