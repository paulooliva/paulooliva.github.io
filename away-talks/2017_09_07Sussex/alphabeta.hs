-- Alpha-beta search with the continuation monad
-- We use trace to watch the searching in action

-- Author: Paulo Oliva
-- Date  : 10/09/2017

import K
import Data.List
import Data.Ord
import Data.Maybe
import Debug.Trace

-- Dependent product with an optional input
prodK ::[Maybe x -> K r x] -> Maybe x -> K r [x]
prodK [phi] x = K (\p -> quant (phi x) (\x -> p [x]))
prodK (phi:phis) x = K (\p -> quant (phi x) (\x' -> quant ((prodK phis) (Just x')) (\xs -> p(x':xs))))

-- available moves
data C = C1 | C2 deriving (Eq,Ord,Show,Read,Enum)

-- alpha-beta memory
type M = [Int]

-- moves with alpha-beta memory
type X = (C,M)

-- payoffs with alpha-beta memory
type R = [Int]

inf = 1000

-- updating the alpha-beta value for player i
update :: Int     -- player index
       -> Int     -- new payoff
       -> M       -- current memory
       -> M       -- updated memory
update i j ms = [ if k == i then max j m else m | (k,m) <- zip [0..] ms ]

-- folding function given game continuation
f :: Int        -- player index
  -> (X -> R)   -- game continuation
  -> (R,M)      -- current payoffs + memory
  -> C          -- next move to consider
  -> (R,M)      -- update payoff + memory
f i p (rs,ms) c = if dead_end then
                     trace " * PRUNE SEARCH" (rs,ms)   -- no point continuing
                  else
                     (r'', update op (rs'!!op) ms)
   where
      no_better j = rs !! j <= ms !! j    -- player j won't do better by coming to this branch
      op = 1 - i                          -- index of the opponent
      dead_end = no_better op             -- opponent is able to (and will) avoid this sub-tree
      rs' = p (c,ms)                      -- try move c with current memory
      better j = rs' !! j > rs !! j       -- playing c improves player j payoff
      r'' = if better i then rs' else rs  -- decide whether to embrace new payoff

phi :: Int        -- player index
    -> Maybe X    -- previous move (including accumulated memory)
    -> (X -> R)   -- game continuation
    -> R          -- best outcome
phi i a p = fst $ foldl (f i p) (rs, update i (rs!!i) ms) [C2]
   where
      ms = if a == Nothing then [-inf,-inf] else (snd.fromJust $ a) 
      rs = p (C1,ms)

phis :: [Maybe X -> K R X]
phis = [ \x -> K (phi i x) | i <- [0,1,0,1] ]

psi :: Maybe X -> K R [X]
psi = prodK phis

-- Example of search tree takes from wikipedia:
-- https://en.wikipedia.org/wiki/Alpha–beta_pruning#/media/File:AB_pruning.svg
-- where pruning takes place we can set q to be undefined
q :: [C] -> [Int]
q [C1,C1,C1,C1] = [4,6]
q [C1,C1,C1,C2] = [7,3]
q [C1,C1,C2,C1] = [3,7]
q [C1,C1,C2,C2] = undefined
q [C1,C2,C1,C1] = [6,4]
q [C1,C2,C1,C2] = [8,2]
q [C1,C2,C2,C1] = undefined
q [C1,C2,C2,C2] = undefined
q [C2,C1,C1,C1] = [3,7]
q [C2,C1,C1,C2] = undefined
q [C2,C1,C2,C1] = [7,3]
q [C2,C1,C2,C2] = [3,7]
q [C2,C2,C1,C1] = undefined
q [C2,C2,C1,C2] = undefined
q [C2,C2,C2,C1] = undefined
q [C2,C2,C2,C2] = undefined

q' :: [X] -> R
q' xs = trace debug rs
   where
      cs = map fst xs    -- list of moves
      rs = q cs          -- outcome on this branch
      cs_deb = show cs
      debug = " -> play = " ++ cs_deb

compute = do
   let xs = quant (psi Nothing) q'
   print xs
