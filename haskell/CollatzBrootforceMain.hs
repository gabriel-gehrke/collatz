import System.Environment 
import Collatz

-- parse the first command line argument, call collatz, print sequence
main = do
   args <- getArgs
   let v = read (head args) :: Integer
   let m = read (head (tail args)) :: Integer
   print (collatz_bruteforce v m)

   return ()
