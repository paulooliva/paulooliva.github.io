-- Selection monad

module J where

import Control.Monad

data J r x = J {selection :: (x -> r) -> x}

instance Functor (J r) where
   fmap = liftM

instance Applicative (J r) where
   pure = return
   (<*>) = ap

monJ :: J r x -> (x -> J r y) -> J r y
monJ e f = J (\p -> b p (a p))
   where
      a p = selection e $ (\x -> p (b p x))
      b p x = selection (f x) p 

instance Monad (J r) where
   return x = J(\p -> x)
   e >>= f = monJ e f
