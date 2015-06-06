-- | This module provides functions for working with object properties
-- | of Javascript objects.

module Data.Foreign.Keys
  ( keys
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Foreign

foreign import unsafeKeys :: Foreign -> Array String

-- | Get an array of the properties defined on a foreign value
keys :: Foreign -> F (Array String)
keys value | isNull value = Left $ TypeMismatch "object" "null"
keys value | isUndefined value = Left $ TypeMismatch "object" "undefined"
keys value | typeOf value == "object" = Right $ unsafeKeys value
keys value = Left $ TypeMismatch "object" (typeOf value)
