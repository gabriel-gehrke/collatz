import System.Environment 
import Collatz

main = do
   args <- getArgs
   let v = read (head args) :: Integer
   
   let seq = collatz v
   print seq

   return ()
