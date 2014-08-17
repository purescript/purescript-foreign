module Data.Foreign.Undefined 
  ( Undefined(..)
  , runUndefined
  
  , readUndefined
  ) where
    
import Data.Maybe  
import Data.Either
import Data.Foreign
    
newtype Undefined a = Undefined (Maybe a)
  
runUndefined :: forall a. Undefined a -> Maybe a
runUndefined (Undefined m) = m  
  
readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)
readUndefined _ value | isUndefined value = pure (Undefined Nothing)
readUndefined f value = Undefined <<< Just <$> f value