module Update where

import Data.List
import Debug.Trace

import Types

-- UPDATE BAR RECURSION

-- We use '*' to count the number of recursive calls
ubr :: FinFct -> (Int -> SelFct) -> Outcome -> Control -> FinFct
ubr s es q phi | test = ubr (plus s (n,x)) es q phi
               | otherwise = s
   where test = trace "*" (inDom n s == Nothing)
         n = phi(hatU s)
         x = (es n)(\y -> q(hatU $ ubr (plus s (n, y)) es q phi))
