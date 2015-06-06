module Data.Foreign.Undefined
  ( Undefined(..)
  , runUndefined
  , readUndefined
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Foreign

-- | A `newtype` wrapper whose `IsForeign` instance correctly handles
-- | undefined values.
-- |
-- | Conceptually, this type represents values which may be `undefined`,
-- | but not `null`.
newtype Undefined a = Undefined (Maybe a)

-- | Unwrap an `Undefined` value
runUndefined :: forall a. Undefined a -> Maybe a
runUndefined (Undefined m) = m

-- | Read an `Undefined` value
readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)
readUndefined _ value | isUndefined value = pure (Undefined Nothing)
readUndefined f value = Undefined <<< Just <$> f value
