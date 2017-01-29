module Data.Foreign.Undefined where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
import Data.Foreign (F, Foreign, isUndefined)

-- | A `newtype` wrapper whose `IsForeign` instance correctly handles
-- | undefined values.
-- |
-- | Conceptually, this type represents values which may be `undefined`,
-- | but not `null`.
newtype Undefined a = Undefined (Maybe a)

derive instance newtypeUndefined :: Newtype (Undefined a) _
derive instance eqUndefined :: (Eq a) => Eq (Undefined a)
derive instance ordUndefined :: (Ord a) => Ord (Undefined a)

instance showUndefined :: (Show a) => Show (Undefined a) where
  show x = "(Undefined " <> show (unwrap x) <> ")"

-- | Unwrap an `Undefined` value
unUndefined :: forall a. Undefined a -> Maybe a
unUndefined (Undefined m) = m

-- | Read an `Undefined` value
readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)
readUndefined _ value | isUndefined value = pure (Undefined Nothing)
readUndefined f value = Undefined <<< Just <$> f value

foreign import writeUndefined :: Foreign
