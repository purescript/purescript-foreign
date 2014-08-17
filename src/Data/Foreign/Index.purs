module Data.Foreign.Index 
  ( Index
  
  , (!)
  , hasProperty
  , hasOwnProperty
  , errorAt
  ) where

import Data.Either
import Data.Foreign 
import Data.Function  
     
infixl 9 !     
      
class (Show i) <= Index i where
  (!) :: Foreign -> i -> F Foreign
  hasProperty :: i -> Foreign -> Boolean
  hasOwnProperty :: i -> Foreign -> Boolean
  errorAt :: i -> ForeignError -> ForeignError
      
foreign import unsafeReadProp
  "function unsafeReadProp(f, s, key, value) { \
  \  if (value && typeof value === 'object') {\
  \    return s(value[key]);\
  \  } else {\
  \    return f;\
  \  }\
  \}" :: forall r k. Fn4 r (Foreign -> r) k Foreign (F Foreign)

foreign import unsafeHasOwnProperty
  "function unsafeHasOwnProperty(prop, value) {\
  \  return value.hasOwnProperty(prop);\
  \}" :: forall k. Fn2 k Foreign Boolean

hasOwnPropertyImpl :: forall k. k -> Foreign -> Boolean
hasOwnPropertyImpl _    value | isNull value = false
hasOwnPropertyImpl _    value | isUndefined value = false
hasOwnPropertyImpl prop value | typeOf value == "object" || typeOf value == "function" = runFn2 unsafeHasOwnProperty prop value
hasOwnPropertyImpl _    value = false

foreign import unsafeHasProperty
  "function unsafeHasProperty(prop, value) {\
  \  return prop in value;\
  \}" :: forall k. Fn2 k Foreign Boolean

hasPropertyImpl :: forall k. k -> Foreign -> Boolean
hasPropertyImpl _    value | isNull value = false
hasPropertyImpl _    value | isUndefined value = false
hasPropertyImpl prop value | typeOf value == "object" || typeOf value == "function" = runFn2 unsafeHasProperty prop value
hasPropertyImpl _    value = false

instance indexString :: Index String where
  (!) value prop = runFn4 unsafeReadProp (Left (PropertyDoesNotExist prop)) pure prop value
  hasProperty = hasPropertyImpl
  hasOwnProperty = hasOwnPropertyImpl
  errorAt = ErrorAtProperty

instance indexNumber :: Index Number where
  (!) value i = runFn4 unsafeReadProp (Left (IndexOutOfBounds i)) pure i value
  hasProperty = hasPropertyImpl
  hasOwnProperty = hasOwnPropertyImpl
  errorAt = ErrorAtIndex
