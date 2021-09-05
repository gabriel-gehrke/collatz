import System.Environment 
import Collatz

-- parse the first command line argument, call collatz, print sequence
main = do
   args <- getArgs
   let v = read (head args) :: Integer
   
   let seq = collatz v
   print seq

   return ()
