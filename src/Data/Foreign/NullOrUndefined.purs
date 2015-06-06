module Data.Foreign.NullOrUndefined
  ( NullOrUndefined(..)
  , runNullOrUndefined
  , readNullOrUndefined
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Foreign

-- | A `newtype` wrapper whose `IsForeign` instance correctly handles
-- | null and undefined values.
-- |
-- | Conceptually, this type represents values which may be `null`
-- | or `undefined`.
newtype NullOrUndefined a = NullOrUndefined (Maybe a)

-- | Unwrap a `NullOrUndefined` value
runNullOrUndefined :: forall a. NullOrUndefined a -> Maybe a
runNullOrUndefined (NullOrUndefined m) = m

-- | Read a `NullOrUndefined` value
readNullOrUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (NullOrUndefined a)
readNullOrUndefined _ value | isNull value || isUndefined value = pure (NullOrUndefined Nothing)
readNullOrUndefined f value = NullOrUndefined <<< Just <$> f value
