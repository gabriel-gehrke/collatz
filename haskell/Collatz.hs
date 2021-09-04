module Collatz where

-- ---------- MAIN IMPLEMENATION -----------------------------------------------------------------------------------------
-- calculates a single step in the collatz sequence
collatz_step :: Integer -> Integer
collatz_step x | x <= 1     = 1           -- the minimum value is 1
               | even x     = x `div` 2   -- the number is even, so the successor is (x / 2)
               | otherwise  = (3*x) + 1   -- the number is odd, so the successor is (3x + 1)

-- calculates the whole collatz sequence for the given "start"-number recursively. The sequence is returned as a list.
collatz :: Integer -> [Integer]
collatz x | x <= 1     = [1]
          | otherwise  = x : collatz (collatz_step x)
-- -----------------------------------------------------------------------------------------------------------------------

type ColRes = (Integer, Integer, Integer, Integer)
collatz_res :: Integer -> ColRes
collatz_res v = (v, len (collatz v), v, list_max (collatz v))

-- calculates the start values for collatz sequences from v up to a number m
collatz_bruteforce :: Integer -> Integer -> ColRes -- start v, maximum start v, returns (v for max seq "height", v for max seq len)
collatz_bruteforce v m | v < 1        = error "invalid start value. must be >= 1."
                       | v > m        = error "start value can't be bigger than maximum start value."
                       | v == m       = collatz_res v
                       | v < m        = collatz_res_max (collatz_bruteforce (v+1) m) (collatz_res v)

collatz_res_max :: ColRes -> ColRes -> ColRes
collatz_res_max (len1sv, len1, max1sv, max1) (len2sv, len2, max2sv, max2) =
   (
      if len1 >= len2 then len1sv else len2sv, 
      max len1 len2,
      if max1 >= max2 then max1sv else max2sv,
      max max1 max2
   )
                        

-- calculates the maximum value in the list
list_max :: Ord a => [a] -> a
list_max [] = error "Empty list!"
list_max [x] = x
list_max (x:xs) = max x (list_max xs)

len :: [a] -> Integer
len [] = 0
len (x:xs) = 1 + len xs
