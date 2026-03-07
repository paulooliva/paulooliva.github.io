-- Haskell code for the 'pirates' example used in the
-- talk given at BLC 2017 (Sussex)

{- Oxford entry exam question:

 A group of seven pirates has 100 gold coins. They have to
 decide amongst themselves how to divide the treasure, but
 must abide by pirate rules:
  - The most senior pirate proposes the division.
  - All of the pirates (including the most senior) vote on
    the division. If half or more vote for the division, it stands.
 If less than half vote for it, they throw the most senior pirate
 overboard and start again.
 What division should the most senior pirate suggest to the other six? -}

-- Author: Paulo Oliva
-- Date  : 05/07/2017
-- Version using continuation monad

import K
import Data.List
import Data.Ord
import Debug.Trace
import Control.Monad (liftM, ap)
import Debug.Trace
import System.Environment
import Data.Maybe

-- GAME SETUP

-- Two possible moves Share or Vote

-- Share contains the distribution of coins for each pirate
type Pirate = Int

-- Whether a pirate agrees with share
type Vote = Bool

-- Collection of all votes
type Poll = [Vote]

-- Share contains the distribution of coins for each pirate
type Share = [Int]

type X = (Share, Poll)

-- Outcome type
type R = [X]

-- Calculate actual share from trace of game
q :: R -> Share
q [(s,v)] = s
q ((s,v):xs) = if 1 + pro >= con then s else q xs
   where
      [con,pro] = (map length).group.sort $ True:False:v

-- Calculate the round in which game finishes
r :: R -> Int
r [(s,v)] = 0
r ((s,v):xs) = if 1 + pro >= con then 0 else 1 + r xs
   where
      [con,pro] = (map length).group.sort $ True:False:v

-- All possible ways to divide n coins amongst i pirates
divide :: Bool -> Int -> Int -> [Share]
divide _ n 1 = [ [n] ]
divide True n i = [ k:xs | k <- reverse [1..n], xs <- divide False (n-k) (i-1) ]
divide False n i = [ k:xs | k <- reverse [0..n], xs <- divide False (n-k) (i-1) ]

-- Current most senior, local strategy
s :: Int -> Int -> Pirate -> (Share -> R) -> R
s nc np i p = p $ fromJust outcome
   where 
      p_shares = divide True nc (np - i)  :: [Share]
      zs = replicate i 0             :: Share
      t_shares = map (zs++) p_shares :: [Share]
      -- find first sharing where games finishes with pirate i or before
      outcome = find (\s -> (r.p $ s) <= i) t_shares

ss :: Int -> Int -> Int -> K R Share
ss nc np i = K (s nc np i)

-- Voting pirates strategy. True means agrees with sharing
v :: Pirate -> (Vote -> R) -> R
v i p = if (q sT)!!i > (q sF)!!i then sT else sF
   where
      sT = p $ True
      sF = p $ False

sv :: Pirate -> K R Vote
sv i = K (v i)

-- Combining voters into a poll
sp :: Int -> Pirate -> K R Poll
sp np i = sequence (map sv [(i+1)..(np-1)])

-- Combining a sharer with the poll, this models a round
e :: Int -> Int -> Int -> K R (Share, Poll)
e nc np i = prod (ss nc np i, sp np i)

-- Combining all np rounds
g :: Int -> Int -> K R [X]
g nc np = sequence (map (e nc np) [0..(np-1)])

main = do
   as <- getArgs
   if length as == 0 then
      putStrLn "pirates <n_coins> <n_pirates>"
   else do
      [nc_s, np_s] <- getArgs
      let nc = read nc_s :: Int
      let np = read np_s :: Int
      let optimal_trace = quant (g nc np) (\x -> x)
      putStrLn $ "Optimal share: " ++ (show $ q optimal_trace)

