local Primes = {
	primes = {}
}

function Primes:BuildPrimesList(n : number) : { [number] : number }
	if #self.primes > 0 and n <= self.primes[#self.primes] then
		return self.primes
	end

	for i = (self.primes[#self.primes] or 1) + 1, n do
		if self:IsPrime(i) then
			table.insert(self.primes, i)
		end
	end

	return self.primes
end

function Primes:IsPrime(n : number) : boolean
	if n < 2 then
		return false
	end

	for _, prime in self.primes do
		if prime > math.sqrt(n) then
			break
		end
		if n % prime == 0 then
			return false
		end
	end
	return true
end

function Primes:GenerateNextPrime() : number
	local candidate = self.primes[#self.primes] or 1
	repeat
		candidate = candidate + 1
	until self:IsPrime(candidate)
	table.insert(self.primes, candidate)
	return candidate
end

function Primes:Decompose(n : number) : { [number] : number }
	local decomp = {}
	local currentNumber = n

	for _, prime in self:BuildPrimesList(n) do
		while currentNumber % prime == 0 do
			table.insert(decomp, prime)
			currentNumber = currentNumber / prime
		end
		if currentNumber == 1 then
			break
		end
	end

	return decomp
end

function Primes:GetNthPrime(n : number) : number
	while #self.primes < n do
		self:GenerateNextPrime()
	end
	return self.primes[n]
end

function Primes:PrimeFactorization(n : number) : table
	local factorization = {}
	for _, prime in self:BuildPrimesList(n) do
		while n % prime == 0 do
			factorization[prime] = (factorization[prime] or 0) + 1
			n = n / prime
		end
		if n == 1 then
			break
		end
	end
	return factorization
end

function Primes:PrimeCount(n : number) : number
	self:BuildPrimesList(n)
	local count = 0
	for _, prime in self.primes do
		if prime <= n then
			count = count + 1
		else
			break
		end
	end
	return count
end

function Primes:IsTwinPrime(n : number) : boolean
	if not self:IsPrime(n) then
		return false
	end
	return self:IsPrime(n-2) or self:IsPrime(n+2)
end

return Primes
