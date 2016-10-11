-- | This module provides functions for working with object properties
-- | of Javascript objects.

module Data.Foreign.Keys
  ( keys
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Foreign (F, Foreign, ForeignError(..), typeOf, isUndefined, isNull)
import Data.NonEmpty as NE

foreign import unsafeKeys :: Foreign -> Array String

-- | Get an array of the properties defined on a foreign value
keys :: Foreign -> F (Array String)
keys value
  | isNull value = Left $ NE.singleton $ TypeMismatch "object" "null"
  | isUndefined value = Left $ NE.singleton $ TypeMismatch "object" "undefined"
  | typeOf value == "object" = Right $ unsafeKeys value
  | otherwise = Left $ NE.singleton $ TypeMismatch "object" (typeOf value)
