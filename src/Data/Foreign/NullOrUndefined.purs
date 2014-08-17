module Data.Foreign.NullOrUndefined 
  ( NullOrUndefined(..)
  , runNullOrUndefined
  
  , readNullOrUndefined
  ) where
    
import Data.Maybe  
import Data.Either
import Data.Foreign
    
newtype NullOrUndefined a = NullOrUndefined (Maybe a)
  
runNullOrUndefined :: forall a. NullOrUndefined a -> Maybe a
runNullOrUndefined (NullOrUndefined m) = m  
  
readNullOrUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (NullOrUndefined a)
readNullOrUndefined _ value | isNull value || isUndefined value = pure (NullOrUndefined Nothing)
readNullOrUndefined f value = NullOrUndefined <<< Just <$> f value