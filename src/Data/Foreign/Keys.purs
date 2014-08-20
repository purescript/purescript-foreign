module Data.Foreign.Keys 
  ( keys
  ) where

import Data.Either
import Data.Foreign
import Data.Function

foreign import unsafeKeys
  "function unsafeKeys(value) { \
  \  return Object.keys(value);\
  \}" :: Foreign -> [String]

keys :: Foreign -> F [String]
keys value | isNull value = Left $ TypeMismatch "object" "null"
keys value | isUndefined value = Left $ TypeMismatch "object" "undefined"
keys value | typeOf value == "object" = Right $ unsafeKeys value
keys value = Left $ TypeMismatch "object" (typeOf value)