-- Continuation monad

module K where

import Control.Monad (liftM, ap)

data K r x = K {quant :: (x -> r) -> r}

instance Functor (K r) where
  fmap f phi = K (\p -> (quant phi)(p . f))

instance Applicative (K r) where
  pure = return
  (<*>) = ap

monK :: K r x -> (x -> K r y) -> K r y
monK phi f = K (\p -> quant phi $ (\x -> quant (f x) p))

instance Monad (K r) where
  return x = K(\p -> p x)
  (>>=) = monK

-- K product
prod :: (K r x, K r y) -> K r (x,y)
prod (e,d) = K $ \p -> quant e (\x -> quant d (\y -> p(x,y))) 
