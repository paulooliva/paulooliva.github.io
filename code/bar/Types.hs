module Types where

import Data.List

-- DATA TYPES

type X = Int -> Int
type R = Int -> Int
type FinFct = [(Int, X)]
type Seq = [X]
type SelFct = (X -> R) -> X 
type Outcome = (Int -> X) -> R
type Control = (Int -> X) -> Int

-- AUXILIARY FUNCTIONS

zero :: X
zero = \x -> 0

inDom :: Int -> FinFct -> Maybe Int
inDom n s = elemIndex n (map fst s)

plus :: FinFct -> (Int, X) -> FinFct
plus s (n,x) = (n,x) : s

hatU :: FinFct -> Int -> X
hatU s n = case inDom n s of
              Nothing -> zero
              Just i -> snd (s !! i) 

hatS :: Seq -> Int -> X
hatS s n = if n < length s then s !! n else zero

showX :: X -> [Int]
showX f = map f [0..99]



