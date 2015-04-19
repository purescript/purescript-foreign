module Data.Foreign.Null
  ( Null(..)
  , runNull
  , readNull
  ) where

import Data.Maybe (Maybe(..))
import Data.Foreign

-- | A `newtype` wrapper whose `IsForeign` instance correctly handles
-- | null values.
-- |
-- | Conceptually, this type represents values which may be `null`,
-- | but not `undefined`.
newtype Null a = Null (Maybe a)

-- | Unwrap a `Null` value
runNull :: forall a. Null a -> Maybe a
runNull (Null m) = m

-- | Read a `Null` value
readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)
readNull _ value | isNull value = pure (Null Nothing)
readNull f value = Null <<< Just <$> f value
