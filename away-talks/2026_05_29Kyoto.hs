{-
  Haskell code used in the tutorial "Bar Recursion" by Paulo Oliva (online),
  presented at the workshop "Continuity, Computability, Constructivity" 
  May 27 - 30, 2026
  Kyoto University, Japan
  https://www.i.h.kyoto-u.ac.jp/ccc2026/
-}

-- Selection monad

module Tutorial where

import Control.Monad

{-
Continuation monad
-}

newtype K r x = K {quant :: (x -> r) -> r}

instance Functor (K r) where
    fmap = liftM

instance Applicative (K r) where
    pure x = K (\k -> k x)
    (<*>) = ap

instance Monad (K r) where
    return = pure
    phi >>= f = K (\p -> quant phi (\gamma -> quant (f gamma) p))

{- Selection monad -}

newtype J r x = J {selection :: (x -> r) -> x}

instance Functor (J r) where
   fmap = liftM

instance Applicative (J r) where
    pure x = J (\p -> x)
    (<*>) = ap

instance Monad (J r) where
    return = pure    
    e >>= f = J (\p -> b p (a p))
        where
            a p = selection e $ (\x -> p (b p x))
            b p x = selection (f x) p

{-
Example 1: SAT solver
-}

-- Selection function for a single variable:
single_choice :: J Bool Bool
single_choice = J (\p -> p True)

-- Selection function for n variables:
n_choice :: Int -> J Bool [Bool]
n_choice n = sequence (replicate n single_choice)

-- Find a satisfying assignment for a predicate q with n variables
-- If no such assignment exists, the result is [False, False, ...].
sat :: Int -> ([Bool] -> Bool) -> [Bool]
sat n = (take n) . (selection . n_choice $ n)

satisfiable :: Int -> ([Bool] -> Bool) -> Bool
satisfiable n q = q (sat n q)

-- Test 1: A simple satisfiable predicate:
q1 :: [Bool] -> Bool
q1 xs = (xs !! 0) && not (xs !! 1) && not (xs !! 2)

-- Test 2: A simple unsatisfiable predicate:
q2 :: [Bool] -> Bool
q2 xs = (xs !! 10) && not (xs !! 10)

-- Test 3: A simple tautology:
q3 :: [Bool] -> Bool
q3 xs = (xs !! 100) || not (xs !! 100)

-- Test 4: Non-tautology, non-contradiction:
q4 :: [Bool] -> Bool
q4 xs = (xs !! 5) && not (xs !! 6)

{-
Example 2: FAN functional for Cantor space
-}

-- Selection function for infinitely many variables:
cantor_choice :: J Bool [Bool]
cantor_choice = sequence (repeat single_choice)

-- Find a satisfying assignment for a predicate q with infinitely many variables:
sat_inf :: ([Bool] -> Bool) -> [Bool]
sat_inf = selection cantor_choice

-- Existential quantification for Cantor space
-- Computes \exists xs . q xs
forsome :: ([Bool] -> Bool) -> Bool
forsome q = q (sat_inf q)

-- Universal quantification for Cantor space
-- Computes \forall xs . q xs
forevery :: ([Bool] -> Bool) -> Bool
forevery q = not (forsome (not . q))

-- Calculate the FAN functional for a predicate q:
-- Ulrich Berger (1990)
fan :: ([Bool] -> Bool) -> Int
fan q = go 0
    where
        go n | fan' n q = n
             | otherwise = go (n + 1)

        fan' :: Int -> ([Bool] -> Bool) -> Bool
        fan' n q = forevery (\xs -> 
                   forevery (\ys -> 
                        take n xs /= take n ys || q xs == q ys))

