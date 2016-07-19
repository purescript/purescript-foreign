module Data.Foreign.Null where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Foreign (F, Foreign, isNull)

-- | A `newtype` wrapper whose `IsForeign` instance correctly handles
-- | null values.
-- |
-- | Conceptually, this type represents values which may be `null`,
-- | but not `undefined`.
newtype Null a = Null (Maybe a)

-- | Unwrap a `Null` value
unNull :: forall a. Null a -> Maybe a
unNull (Null m) = m

-- | Read a `Null` value
readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)
readNull _ value | isNull value = pure (Null Nothing)
readNull f value = Null <<< Just <$> f value

foreign import writeNull :: Foreign
