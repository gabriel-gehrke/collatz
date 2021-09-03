module Collatz
where

collatz_step :: Integer -> Integer
collatz_step x | x <= 1     = 1
               | even x     = x `div` 2
               | otherwise  = (3*x) + 1

collatz :: Integer -> [Integer]
collatz x | x <= 1     = [1]
          | otherwise  = x : collatz (collatz_step x)
