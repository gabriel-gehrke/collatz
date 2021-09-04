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

-- calculates the start values for collatz sequences up to a number m
collatz_bruteforce :: Integer -> Integer -> (Integer, Integer, Integer, Integer) -- start v, maximum start v, returns (v for max seq "height", v for max seq len)
collatz_bruteforce v m | v < 1        = error "invalid start value. must be >= 1."
                       | v > m        = error "start value can't be bigger than maximum start value."
                       | v == m       = (v, len (collatz v), v, list_max (collatz v))
                       | v < m        = (maxlen_sv, maxlen, maxheight_sv, maxheight)
                                         where
                                            (nextlen_sv, nextlen, nextmax_sv, nextmax) = collatz_bruteforce (v+1) m
                                            _seq = collatz v
                                            _height = list_max _seq
                                            _length = len _seq
                                            maxlen = max (_length) (nextlen)
                                            maxheight = max (_height) (nextmax)
                                            maxlen_sv = if _length > nextlen then v else nextlen_sv
                                            maxheight_sv = if _height > nextmax then v else nextmax_sv




-- calculates the maximum value in the list
list_max :: Ord a => [a] -> a
list_max [] = error "Empty list!"
list_max [x] = x
list_max (x:xs) = max x (list_max xs)

len :: [a] -> Integer
len [] = 0
len (x:xs) = 1 + len xs
