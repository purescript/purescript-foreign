-- | This module defines types and functions for working with _foreign_
-- | data.

module Data.Foreign
  ( Foreign
  , ForeignError(..)
  , Prop(..)
  , F
  , parseJSON
  , toForeign
  , unsafeFromForeign
  , unsafeReadTagged
  , typeOf
  , tagOf
  , isNull
  , isUndefined
  , isArray
  , readString
  , readChar
  , readBoolean
  , readNumber
  , readInt
  , readArray
  , writeObject
  ) where

import Prelude

import Data.Either (Either(..), either)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Int as Int
import Data.Maybe (maybe)
import Data.String (toChar)

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
  = TypeMismatch (Array String) String
  | ErrorAtIndex Int ForeignError
  | ErrorAtProperty String ForeignError
  | JSONError String

instance showForeignError :: Show ForeignError where
  show (ErrorAtIndex i e) = "Error at array index " <> show i <> ": " <> show e
  show (ErrorAtProperty prop e) = "Error at property " <> show prop <> ": " <> show e
  show (JSONError s) = "JSON error: " <> s
  show (TypeMismatch exps act) = "Type mismatch: expected " <> to_s exps <> ", found " <> act
    where
      to_s [] = "???"
      to_s [typ] = typ
      to_s typs = "one of " <> show typs

derive instance eqForeignError :: Eq ForeignError
derive instance ordForeignError :: Ord ForeignError

-- | An error monad, used in this library to encode possible failure when
-- | dealing with foreign data.
type F = Either ForeignError

foreign import parseJSONImpl :: forall r. Fn3 (String -> r) (Foreign -> r) String r

-- | Attempt to parse a JSON string, returning the result as foreign data.
parseJSON :: String -> F Foreign
parseJSON json = runFn3 parseJSONImpl (Left <<< JSONError) Right json

-- | Coerce any value to the a `Foreign` value.
foreign import toForeign :: forall a. a -> Foreign

-- | Unsafely coerce a `Foreign` value.
foreign import unsafeFromForeign :: forall a. Foreign -> a

-- | Read the Javascript _type_ of a value
foreign import typeOf :: Foreign -> String

-- | Read the Javascript _tag_ of a value.
-- |
-- | This function wraps the `Object.toString` method.
foreign import tagOf :: Foreign -> String

-- | Unsafely coerce a `Foreign` value when the value has a particular `tagOf`
-- | value.
unsafeReadTagged :: forall a. String -> Foreign -> F a
unsafeReadTagged tag value | tagOf value == tag = pure (unsafeFromForeign value)
unsafeReadTagged tag value = Left (TypeMismatch [tag] (tagOf value))

-- | Test whether a foreign value is null
foreign import isNull :: Foreign -> Boolean

-- | Test whether a foreign value is undefined
foreign import isUndefined :: Foreign -> Boolean

-- | Test whether a foreign value is an array
foreign import isArray :: Foreign -> Boolean

-- | Attempt to coerce a foreign value to a `String`.
readString :: Foreign -> F String
readString = unsafeReadTagged "String"

-- | Attempt to coerce a foreign value to a `Char`.
readChar :: Foreign -> F Char
readChar value = either (const error) fromString (readString value)
  where
  fromString :: String -> F Char
  fromString = maybe error pure <<< toChar

  error :: F Char
  error = Left $ TypeMismatch ["Char"] (tagOf value)

-- | Attempt to coerce a foreign value to a `Boolean`.
readBoolean :: Foreign -> F Boolean
readBoolean = unsafeReadTagged "Boolean"

-- | Attempt to coerce a foreign value to a `Number`.
readNumber :: Foreign -> F Number
readNumber = unsafeReadTagged "Number"

-- | Attempt to coerce a foreign value to an `Int`.
readInt :: Foreign -> F Int
readInt value = either (const error) fromNumber (readNumber value)
  where
  fromNumber :: Number -> F Int
  fromNumber = maybe error pure <<< Int.fromNumber

  error :: F Int
  error = Left $ TypeMismatch ["Int"] (tagOf value)

-- | Attempt to coerce a foreign value to an array.
readArray :: Foreign -> F (Array Foreign)
readArray value | isArray value = pure $ unsafeFromForeign value
readArray value = Left (TypeMismatch ["array"] (tagOf value))

-- | A key/value pair for an object to be written as a `Foreign` value.
newtype Prop = Prop { key :: String, value :: Foreign }

-- | Constructs a JavaScript `Object` value (typed as `Foreign`) from an array
-- | of `Prop`s.
foreign import writeObject :: Array Prop -> Foreign
