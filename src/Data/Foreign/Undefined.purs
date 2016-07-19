module Data.Foreign.Undefined where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Foreign (F, Foreign, isUndefined)

-- | A `newtype` wrapper whose `IsForeign` instance correctly handles
-- | undefined values.
-- |
-- | Conceptually, this type represents values which may be `undefined`,
-- | but not `null`.
newtype Undefined a = Undefined (Maybe a)

-- | Unwrap an `Undefined` value
unUndefined :: forall a. Undefined a -> Maybe a
unUndefined (Undefined m) = m

-- | Read an `Undefined` value
readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)
readUndefined _ value | isUndefined value = pure (Undefined Nothing)
readUndefined f value = Undefined <<< Just <$> f value

foreign import writeUndefined :: Foreign
