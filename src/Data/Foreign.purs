module Data.Foreign 
  ( Foreign()
  , ForeignError(..)
  
  , F()
  
  , parseJSON
  
  , toForeign
  , unsafeFromForeign
  
  , typeOf
  , tagOf
  
  , isNull
  , isUndefined
  , isArray
  
  , readString
  , readBoolean
  , readNumber
  , readArray
  ) where
     
import Data.Array
import Data.Either
import Data.Function

foreign import data Foreign :: *

data ForeignError 
  = TypeMismatch String String
  | ErrorAtIndex Number ForeignError
  | ErrorAtProperty String ForeignError
  | JSONError String
  
instance showForeignError :: Show ForeignError where
  show (TypeMismatch exp act) = "Type mismatch: expected " ++ exp ++ ", found " ++ act 
  show (ErrorAtIndex i e) = "Error at array index " ++ show i ++ ": " ++ show e
  show (ErrorAtProperty prop e) = "Error at property " ++ show prop ++ ": " ++ show e
  show (JSONError s) = "JSON error: " ++ s
  
type F = Either ForeignError  
  
foreign import parseJSONImpl
  "function parseJSONImpl(left, right, str) {\
  \  try {\
  \    return right(JSON.parse(str));\
  \  } catch (e) {\
  \    return left(e.toString());\
  \  } \
  \}" :: forall r. Fn3 (String -> r) (Foreign -> r) String r
  
parseJSON :: String -> F Foreign
parseJSON json = runFn3 parseJSONImpl (Left <<< JSONError) Right json
  
foreign import toForeign
  "function toForeign(value) {\
  \  return value;\
  \}" :: forall a. a -> Foreign
  
foreign import unsafeFromForeign
  "function unsafeFromForeign(value) {\
  \  return value;\
  \}" :: forall a. Foreign -> a
  
foreign import typeOf
  "function typeOf(value) {\
  \  return typeof value;\
  \}" :: Foreign -> String
  
foreign import tagOf
  "function tagOf(value) {\
  \  return Object.prototype.toString.call(value).slice(8, -1);\
  \}" :: Foreign -> String
  
unsafeReadPrim :: forall a. String -> Foreign -> F a
unsafeReadPrim tag value | tagOf value == tag = pure (unsafeFromForeign value)
unsafeReadPrim tag value = Left (TypeMismatch tag (tagOf value))

foreign import isNull
  "function isNull(value) {\
  \  return value === null;\
  \}" :: Foreign -> Boolean
  
foreign import isUndefined
  "function isUndefined(value) {\
  \  return value === undefined;\
  \}" :: Foreign -> Boolean

foreign import isArray 
  "function isArray(value) {\
  \  return Array.isArray(value);\
  \}" :: Foreign -> Boolean

readString :: Foreign -> F String
readString = unsafeReadPrim "String"
  
readBoolean :: Foreign -> F Boolean
readBoolean = unsafeReadPrim "Boolean"
  
readNumber :: Foreign -> F Number
readNumber = unsafeReadPrim "Number"

readArray :: Foreign -> F [Foreign]
readArray value | isArray value = pure $ unsafeFromForeign value
readArray value = Left (TypeMismatch "array" (tagOf value))
