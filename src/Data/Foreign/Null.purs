module Data.Foreign.Null where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
import Data.Foreign (F, Foreign, isNull)

-- | A `newtype` wrapper whose `IsForeign` instance correctly handles
-- | null values.
-- |
-- | Conceptually, this type represents values which may be `null`,
-- | but not `undefined`.
newtype Null a = Null (Maybe a)

derive instance newtypeNull :: Newtype (Null a) _
derive instance eqNull :: (Eq a) => Eq (Null a)
derive instance ordNull :: (Ord a) => Ord (Null a)

instance showNull :: (Show a) => Show (Null a) where
  show x = "(Null " <> show (unwrap x) <> ")"

-- | Unwrap a `Null` value
unNull :: forall a. Null a -> Maybe a
unNull (Null m) = m

-- | Read a `Null` value
readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)
readNull _ value | isNull value = pure (Null Nothing)
readNull f value = Null <<< Just <$> f value

foreign import writeNull :: Foreign
