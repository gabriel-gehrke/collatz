module Collatz
where

-- calculates a single step in the collatz sequence
collatz_step :: Integer -> Integer
collatz_step x | x <= 1     = 1           -- the minimum value is 1
               | even x     = x `div` 2   -- the number is even, so the successor is (x / 2)
               | otherwise  = (3*x) + 1   -- the number is odd, so the successor is (3x + 1)

-- calculates the whole collatz sequence for the given "start"-number recursively. The sequence is returned as a list.
collatz :: Integer -> [Integer]
collatz x | x <= 1     = [1]
          | otherwise  = x : collatz (collatz_step x)
