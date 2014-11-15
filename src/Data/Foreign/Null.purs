module Data.Foreign.Null
  ( Null(..)
  , runNull

  , readNull
  ) where

import Data.Maybe
import Data.Either
import Data.Foreign

newtype Null a = Null (Maybe a)

runNull :: forall a. Null a -> Maybe a
runNull (Null m) = m

readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)
readNull _ value | isNull value = pure (Null Nothing)
readNull f value = Null <<< Just <$> f value
