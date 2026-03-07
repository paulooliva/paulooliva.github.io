module Spector where

import Data.List
import Debug.Trace

import Types

-- SPECTOR BAR RECURSION

-- We use '*' to count the number of recursive calls
sbr :: Seq -> (Int -> SelFct) -> Outcome -> Control -> Seq
sbr s es q phi | test = s
               | otherwise = sbr (s ++ [x]) es q phi
   where test = trace "*" (n < length s)
         n = phi(hatS s)
         x = (es (length s))(\y -> q(hatS $ sbr (s ++ [y]) es q phi))

