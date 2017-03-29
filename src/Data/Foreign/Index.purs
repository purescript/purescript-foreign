-- | This module defines a type class for types which act like
-- | _property indices_.

module Data.Foreign.Index
  ( class Index
  , class Indexable
  , readProp
  , readIndex
  , ix, (!)
  , index
  , hasProperty
  , hasOwnProperty
  , errorAt
  ) where

import Prelude

import Control.Monad.Except.Trans (ExceptT)

import Data.Foreign (Foreign, F, ForeignError(..), typeOf, isUndefined, isNull, fail)
import Data.Function.Uncurried (Fn2, runFn2, Fn4, runFn4)
import Data.Identity (Identity)
import Data.List.NonEmpty (NonEmptyList)

-- | This type class identifies types that act like _property indices_.
-- |
-- | The canonical instances are for `String`s and `Int`s.
class Index i where
  index :: Foreign -> i -> F Foreign
  hasProperty :: i -> Foreign -> Boolean
  hasOwnProperty :: i -> Foreign -> Boolean
  errorAt :: i -> ForeignError -> ForeignError

class Indexable a where
  ix :: forall i. Index i => a -> i -> F Foreign

infixl 9 ix as !

foreign import unsafeReadPropImpl :: forall r k. Fn4 r (Foreign -> r) k Foreign r

unsafeReadProp :: forall k. k -> Foreign -> F Foreign
unsafeReadProp k value =
  runFn4 unsafeReadPropImpl (fail (TypeMismatch "object" (typeOf value))) pure k value

-- | Attempt to read a value from a foreign value property
readProp :: String -> Foreign -> F Foreign
readProp = unsafeReadProp

-- | Attempt to read a value from a foreign value at the specified numeric index
readIndex :: Int -> Foreign -> F Foreign
readIndex = unsafeReadProp

foreign import unsafeHasOwnProperty :: forall k. Fn2 k Foreign Boolean

hasOwnPropertyImpl :: forall k. k -> Foreign -> Boolean
hasOwnPropertyImpl _ value | isNull value = false
hasOwnPropertyImpl _ value | isUndefined value = false
hasOwnPropertyImpl p value | typeOf value == "object" || typeOf value == "function" = runFn2 unsafeHasOwnProperty p value
hasOwnPropertyImpl _ value = false

foreign import unsafeHasProperty :: forall k. Fn2 k Foreign Boolean

hasPropertyImpl :: forall k. k -> Foreign -> Boolean
hasPropertyImpl _ value | isNull value = false
hasPropertyImpl _ value | isUndefined value = false
hasPropertyImpl p value | typeOf value == "object" || typeOf value == "function" = runFn2 unsafeHasProperty p value
hasPropertyImpl _ value = false

instance indexString :: Index String where
  index = flip readProp
  hasProperty = hasPropertyImpl
  hasOwnProperty = hasOwnPropertyImpl
  errorAt = ErrorAtProperty

instance indexInt :: Index Int where
  index = flip readIndex
  hasProperty = hasPropertyImpl
  hasOwnProperty = hasOwnPropertyImpl
  errorAt = ErrorAtIndex

instance indexableForeign :: Indexable Foreign where
  ix = index

instance indexableExceptT :: Indexable (ExceptT (NonEmptyList ForeignError) Identity Foreign) where
  ix f i = flip index i =<< f
