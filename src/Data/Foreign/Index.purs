module Data.Foreign.Index 
  ( Index
  
  , prop
  , index
  
  , (!)
  , hasProperty
  , hasOwnProperty
  , errorAt
  ) where

import Data.Either
import Data.Foreign 
import Data.Function  
     
infixl 9 !     
      
class Index i where
  (!) :: Foreign -> i -> F Foreign
  hasProperty :: i -> Foreign -> Boolean
  hasOwnProperty :: i -> Foreign -> Boolean
  errorAt :: i -> ForeignError -> ForeignError
      
foreign import unsafeReadPropImpl
  "function unsafeReadProp(f, s, key, value) { \
  \  if (value && typeof value === 'object') {\
  \    return s(value[key]);\
  \  } else {\
  \    return f;\
  \  }\
  \}" :: forall r k. Fn4 r (Foreign -> r) k Foreign (F Foreign)

unsafeReadProp :: forall k. k -> Foreign -> F Foreign
unsafeReadProp k value = runFn4 unsafeReadPropImpl (Left (TypeMismatch "object" (typeOf value))) pure k value

prop :: String -> Foreign -> F Foreign
prop = unsafeReadProp 

index :: Number -> Foreign -> F Foreign
index = unsafeReadProp

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
  (!) = flip prop
  hasProperty = hasPropertyImpl
  hasOwnProperty = hasOwnPropertyImpl
  errorAt = ErrorAtProperty

instance indexNumber :: Index Number where
  (!) = flip index
  hasProperty = hasPropertyImpl
  hasOwnProperty = hasOwnPropertyImpl
  errorAt = ErrorAtIndex
