-- | This module defines types and functions for working with _foreign_
-- | data.

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

-- | A type for _foreign data_.
-- |
-- | Foreign data is data from any external _unknown_ or _unreliable_
-- | source, for which it cannot be guaranteed that the runtime representation
-- | conforms to that of any particular type.
-- |
-- | Suitable applications of `Foreign` are
-- |
-- | - To represent responses from web services
-- | - To integrate with external JavaScript libraries.
foreign import data Foreign :: *

-- | A type for runtime type errors
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

instance eqForeignError :: Eq ForeignError where
  (==) (TypeMismatch a b) (TypeMismatch a' b') = a == a' && b == b'
  (==) (ErrorAtIndex i e) (ErrorAtIndex i' e') = i == i' && e == e'
  (==) (ErrorAtProperty p e) (ErrorAtProperty p' e') = p == p' && e == e'
  (==) (JSONError s) (JSONError s') = s == s'
  (==) _ _ = false
  (/=) a b = not (a == b)

-- | An error monad, used in this library to encode possible failure when
-- | dealing with foreign data.
type F = Either ForeignError

foreign import parseJSONImpl
  """
  function parseJSONImpl(left, right, str) {
    try {
      return right(JSON.parse(str));
    } catch (e) {
      return left(e.toString());
    }
  }
  """ :: forall r. Fn3 (String -> r) (Foreign -> r) String r

-- | Attempt to parse a JSON string, returning the result as foreign data.
parseJSON :: String -> F Foreign
parseJSON json = runFn3 parseJSONImpl (Left <<< JSONError) Right json

-- | Coerce any value to the a `Foreign` value.
foreign import toForeign
  """
  function toForeign(value) {
    return value;
  }
  """ :: forall a. a -> Foreign

-- | Unsafely coerce a `Foreign` value.
foreign import unsafeFromForeign
  """
  function unsafeFromForeign(value) {
    return value;
  }
  """ :: forall a. Foreign -> a

-- | Read the Javascript _type_ of a value
foreign import typeOf
  """
  function typeOf(value) {
    return typeof value;
  }
  """ :: Foreign -> String

-- | Read the Javascript _tag_ of a value.
-- |
-- | This function wraps the `Object.toString` method.
foreign import tagOf
  """
  function tagOf(value) {
    return Object.prototype.toString.call(value).slice(8, -1);
  }
  """ :: Foreign -> String

unsafeReadPrim :: forall a. String -> Foreign -> F a
unsafeReadPrim tag value | tagOf value == tag = pure (unsafeFromForeign value)
unsafeReadPrim tag value = Left (TypeMismatch tag (tagOf value))

-- | Test whether a foreign value is null
foreign import isNull
  """
  function isNull(value) {
    return value === null;
  }
  """ :: Foreign -> Boolean

-- | Test whether a foreign value is undefined
foreign import isUndefined
  """
  function isUndefined(value) {
    return value === undefined;
  }
  """ :: Foreign -> Boolean

-- | Test whether a foreign value is an array
foreign import isArray
  """
  var isArray = Array.isArray || function(value) {
    return Object.prototype.toString.call(value) === '[object Array]';
  };
  """ :: Foreign -> Boolean

-- | Attempt to coerce a foreign value to a `String`.
readString :: Foreign -> F String
readString = unsafeReadPrim "String"

-- | Attempt to coerce a foreign value to a `Boolean`.
readBoolean :: Foreign -> F Boolean
readBoolean = unsafeReadPrim "Boolean"

-- | Attempt to coerce a foreign value to a `Number`.
readNumber :: Foreign -> F Number
readNumber = unsafeReadPrim "Number"

-- | Attempt to coerce a foreign value to an array.
readArray :: Foreign -> F [Foreign]
readArray value | isArray value = pure $ unsafeFromForeign value
readArray value = Left (TypeMismatch "array" (tagOf value))
