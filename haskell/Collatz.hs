module Collatz
where

collatz_step :: Int -> Int
collatz_step x | x <= 1     = 1
               | even x     = x `div` 2
               | otherwise  = (3*x) + 1

collatz :: Int -> [Int]
collatz x | x <= 1     = [1]
          | otherwise  = x : collatz (collatz_step x)
