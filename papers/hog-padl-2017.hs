-- Accompanying Haskell code for paper:
-- 
-- Title: Selection Equilibria of Higher-Order Games
-- Authors: Jules Hedges
--          Paulo Oliva
--          Evguenia Shprits
--          Viktor Winschel
--          Philipp Zahn
--
-- Tested on GHC 7.10
-- Submitted to PADL 2017

import Prelude hiding (max)
import Data.List (nub, maximumBy)

-- List the elements of an enum
-- We assume that x is finite, so this list is finite
elements :: (Enum x) => [x]
elements = enumFrom (toEnum 0)

-- Quantifiers and selection functions
-- The returned lists must be nonempty and finite

type Q r x = (x -> r) -> [r]
type S r x = (x -> r) -> [x]

-- Higher-order games
-- Invariant: If (n, es, q) is a game, then es has length n, and q xs is meaningful only when xs has length n.

type Game r x = (Int, [S r x], [x] -> r)

-- Enumeration of all possible strategies with n players
-- (sequence is n-fold cartesian product for the list monad)
strategies :: (Enum x) => Int -> [[x]]
strategies n = sequence (replicate n elements)

-- Examples of quantifiers and selection functions

max :: (Enum x) => (r -> r -> Ordering) -> Q r x
max order p = [maximumBy order (map p elements)]

argmax :: (Enum x, Eq r) => (r -> r -> Ordering) -> S r x
argmax order p = [x | x <- elements, p x == maximum]
  where maximum = maximumBy order (map p elements)

fix :: (Eq x, Enum x) => S x x
fix p = if null fixpoints then elements else fixpoints
  where fixpoints = [x | x <- elements, x == p x]

-- Overline operators

overlineS :: (Eq r) => S r x -> Q r x
overlineS e p = nub [p x | x <- e p]

overlineQ :: (Enum x, Eq r) => Q r x -> S r x
overlineQ phi p = [x | x <- elements, p x `elem` phi p]

-- Unilateral maps

unilateral :: Int -> ([x] -> r) -> [x] -> x -> r
unilateral i q xs x' = q [xs' j | j <- [0 .. n-1]]
  where xs' j | (j == i)    = x'
              | (otherwise) = xs!!j
        n = length xs

-- Testing deviation of individual players

deviatesQ :: (Eq r) => Game r x -> [x] -> Int -> Bool
deviatesQ (_, es, q) xs i = not (q xs `elem` overlineS (es!!i) (unilateral i q xs))

deviatesS :: (Eq x) => Game r x -> [x] -> Int -> Bool
deviatesS (_, es, q) xs i = not (xs!!i `elem` (es!!i) (unilateral i q xs))

-- Equilibrium testing
-- Return either Right () indicating equilibrium, or a nonempty list of players who prefer to deviate

equilibriumQ :: (Eq r) => Game r x -> [x] -> Either [Int] ()
equilibriumQ g@(n, _, _) xs = if null deviates then Right () else Left deviates
  where deviates = [i | i <- [0 .. n-1], deviatesQ g xs i]

equilibriumS :: (Eq x) => Game r x -> [x] -> Either [Int] ()
equilibriumS g@(n, _, _) xs = if null deviates then Right () else Left deviates
  where deviates = [i | i <- [0 .. n-1], deviatesS g xs i]

-- The voting game

data X = A | B deriving (Eq, Ord, Enum, Show)

maj :: [X] -> X
maj [A,A,_] = A
maj [A,_,A] = A
maj [_,A,A] = A
maj [_,_,_] = B

-- Orderings with A > B, B > A respectively
order1, order2 :: X -> X -> Ordering
order1 = flip compare
order2 = compare

-- Two examples from selection 3.1
game1, game2 :: Game X X
game1 = (3, [argmax order1, argmax order1, argmax order2], maj)
game2 = (3, [argmax order1, fix, fix], maj)

-- Coordination game
game3 :: Game X X
game3 = (3, [fix, fix, fix], maj)

{-
Example usage, to verify tables from the paper:

1. Calculating deviating players in game1 with respect
   to quantifier equilibrium, for each of the 9 possible strategies
   Rigth () indicates an equilibrium, i.e. no players wish to deviate
   We can see that there are three equilibrium strategies, namely
   [A,A,A], [A,A,B] and [B,B,B]

*Games Games> mapM_ print $ (zip ((strategies 3) :: [[X]]) $ map (equilibriumQ game1) (strategies 3))
([A,A,A],Right ())
([A,A,B],Right ())
([A,B,A],Left [2])
([A,B,B],Left [1])
([B,A,A],Left [2])
([B,A,B],Left [0])
([B,B,A],Left [0,1])
([B,B,B],Right ())

2. Calculating deviating player in game2 with respect
   to selection equilibrium. In this case there are four
   equilibrium strategy profiles.

*Games Games> mapM_ print $ (zip ((strategies 3) :: [[X]]) $ map (equilibriumS game2) (strategies 3))
([A,A,A],Right ())
([A,A,B],Left [2])
([A,B,A],Left [1])
([A,B,B],Right ())
([B,A,A],Right ())
([B,A,B],Left [0,1])
([B,B,A],Left [0,2])
([B,B,B],Right ())

3. In the full coordination game3 one can see that there are only 
   two selection equilibrium, but all 9 strategies are in quantifier
   equilibrium.

*Games Games> mapM_ print $ (zip ((strategies 3) :: [[X]]) $ map (equilibriumS game3) (strategies 3))
([A,A,A],Right ())
([A,A,B],Left [2])
([A,B,A],Left [1])
([A,B,B],Left [0])
([B,A,A],Left [0])
([B,A,B],Left [1])
([B,B,A],Left [2])
([B,B,B],Right ())

*Games Games> mapM_ print $ (zip ((strategies 3) :: [[X]]) $ map (equilibriumQ game3) (strategies 3))
([A,A,A],Right ())
([A,A,B],Right ())
([A,B,A],Right ())
([A,B,B],Right ())
([B,A,A],Right ())
([B,A,B],Right ())
([B,B,A],Right ())
([B,B,B],Right ())

-}
