-- Haskell code for the first example used in the
-- talk given at BLC 2017 (Sussex)
--
-- Author: Paulo Oliva
-- Date  : 10/09/2017

import Data.List
import Data.Maybe
import J

-- xs is a permutation of vs
perm :: [Int] -> [Int] -> Bool
perm vs [] = True
perm vs (x:xs) = if not (elem x vs) then False else perm (delete x vs) xs

-- Test whether a proposed solution xs is a good solution
-- We use the following enumeration of the matrix cells:
-- 0
-- 1 2 3 4
-- 5 6 7 8
-- 9
good :: [Int] -> Bool
good xs = test1 && test2
   where 
      test1 = perm [1..10] xs
      sum1 = (xs !! 1) + (xs !! 2) + (xs !! 3) + (xs !! 4)
      sum2 = (xs !! 5) + (xs !! 6) + (xs !! 7) + (xs !! 8)
      sum3 = (xs !! 0) + (xs !! 1) + (xs !! 5) + (xs !! 9)
      test2 = (sum1 == sum2) && (sum2 == sum3)

-- Selection function: Performing local search
e :: (Int -> Bool) -> Int
e p = if sol == Nothing then 0 else fromJust sol
   where
      sol = find p [1..10]

es :: [J Bool Int]
es = replicate 10 (J e)

-- Combining selection functions: Global search
super :: J Bool [Int]
super = sequence es

-- An optimal play
play :: [Int]
play = selection super good

-- Pretty print of the solution xs
pprint :: [Int] -> IO ()
pprint xs = do
   print $ xs !! 0
   putStr $ show (xs !! 1) ++ " "
   putStr $ show (xs !! 2) ++ " "
   putStr $ show (xs !! 3) ++ " "
   putStrLn $ show (xs !! 4)
   putStr $ show (xs !! 5) ++ " "
   putStr $ show (xs !! 6) ++ " "
   putStr $ show (xs !! 7) ++ " "
   putStrLn $ show (xs !! 8)
   print $ xs !! 9

main = do pprint play
