# EasyMath
✖️➕ Blazingly fast and easy Maths Utility library

# StrMath
I've designed the StrMath library to allow for super quick arithmetic operations on large _integers_ represented as strings. This allows handling numbers that would otherwise exceed the typical numeric limits in Lua, providing functionality for basic arithmetic such as addition, subtraction, multiplication, division, modulus, and exponentiation. I've employed some special techniques such as Karatsuba multiplication which is used to handle multiplication more efficiently, and utilities are included for validating and manipulating these string-represented numbers.

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
