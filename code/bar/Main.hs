module Main where

import Debug.Trace
-- Code for "No injection" case study
-- Paper: Spector bar recursion over finite partial functions
-- Authors: Paulo Oliva and Thomas Powell
-- Date: 01/07/2015

import Types
import Spector
import Update

type Inj = (Int -> Int) -> Int

-- Selection function
es :: Inj -> Int -> SelFct
es h n p | h(p zero) == n = p zero
         | otherwise = zero

-- diagonalisation (also the outcome function)
q :: (Int -> X) -> X
q a = \n -> (a n n) + 1

-- Control function
phi :: Inj -> Control
phi h a = h(q a)

-- Experimental values for H (supposed injection from N^N to N)
-- The H's used in the paper are h5 and h6 with n = 3,4,5

h1 :: Inj
h1 f | (f 0 == 1) && (f 1 == 1) = 1
     | otherwise = 0

h2 :: Inj
h2 f | (f 0 == 2) && (f 1 == 1) = 2
     | (f 0 == 1) && (f 1 == 2) = 1
     | otherwise = 0

h3 :: Inj
h3 f  | (f 2 == 2) = 1
      | (f 0 == 2) && (f 2 == 1) = 2
      | otherwise = 0

h4 :: Inj
h4 f  | (f 3 == 2) = 0
      | (f 2 == 2) && (f 0 == 2) = 3
      | (f 2 == 2) && (f 0 == 1) = 0
      | (f 1 == 2) = 2
      | otherwise = 1

h5 :: Int -> Inj
h5 n f = product [ 1 + f i | i <- [0..(n-1)] ]

h6 :: Int -> Inj
h6 n f = product [ (i+1)^(1 + f i) | i <- [0..(n-1)] ]

h7 :: Int -> Inj
h7 n f = if sol == [] then n else (fst.head $ sol)
  where
    xs = map f [0..n]
    ds = zipWith (-) (tail xs) xs
    is = zip [0..] ds
    sol = filter (\(x,y) -> (y>0)) is

-- Solutions using SBR on various values of H
-- Here we computing the two functions alpha and beta (f and g)
-- and the point i where they differ
sp_s h = sbr [] (es h) q (phi h)
sp_a h = hatS (sp_s h)
sp_f h = q (sp_a h)
sp_i h = (phi h) (sp_a h)
sp_g h = (sp_a h) (sp_i h)

-- Solutions using SBR on various values of H
-- Here we computing the two functions alpha and beta (f and g)
-- and the point i where they differ
up_s h = ubr [] (es h) q (phi h)
up_a h = hatU (up_s h)
up_f h = q (up_a h)
up_i h = (phi h) (up_a h)
up_g h = (up_a h) (up_i h)

-- Printing to files

sp_calc :: Inj -> IO ()
sp_calc h = do
   print "\nSpector bar recursion\n"
   let out = appendFile "out-spec.txt"
   let s = sp_s h
   let f = sp_f h
   let g = sp_g h
   -- out $ "Size of domain: " ++ (show.length $ s) ++ "\n"
   out $ "Approximation to f: " ++ (show $ showX f) ++ "\n"
   out $ "Approximation to g: " ++ (show $ showX g) ++ "\n"

up_calc :: Inj -> IO ()
up_calc h = do
   print "\nSymmetric bar recursion\n"
   let out = appendFile "out-sym.txt"
   let s = up_s h
   let f = up_f h
   let g = up_g h
   -- out $ "Size of domain: " ++ (show.length $ s) ++ "\n"
   out $ "Approximation to f: " ++ (show $ showX f) ++ "\n"
   out $ "Approximation to g: " ++ (show $ showX g) ++ "\n"

-- First table section 3.4 was produced with h5 and n = 3,4,5
-- Here is the case n = 3
-- To count the number of recursive calls see the number of '*'s printed on screen
-- (compile and run as '$ Main &> out-runtime.txt')
main = do let h = h5 4
          -- sp_calc h
          up_calc h
