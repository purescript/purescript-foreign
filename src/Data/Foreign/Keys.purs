-- | This module provides functions for working with object properties
-- | of Javascript objects.

module Data.Foreign.Keys
  ( keys
  ) where

import Prelude

import Data.Foreign (F, Foreign, ForeignError(..), typeOf, isUndefined, isNull, fail)

foreign import unsafeKeys :: Foreign -> Array String

-- | Get an array of the properties defined on a foreign value
keys :: Foreign -> F (Array String)
keys value
  | isNull value = fail $ TypeMismatch "object" "null"
  | isUndefined value = fail $ TypeMismatch "object" "undefined"
  | typeOf value == "object" = pure $ unsafeKeys value
  | otherwise = fail $ TypeMismatch "object" (typeOf value)
