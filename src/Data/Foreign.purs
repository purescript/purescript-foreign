-- | This module defines types and functions for working with _foreign_
-- | data.

module Data.Foreign
  ( Foreign
  , ForeignError(..)
  , MultipleErrors(..)
  , Prop(..)
  , F
  , renderForeignError
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
  , fail
  , writeObject
  ) where

import Prelude

import Control.Monad.Except (Except, throwError, mapExcept)

import Data.Either (Either(..), either)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Int as Int
import Data.List.NonEmpty (NonEmptyList)
import Data.List.NonEmpty as NEL
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

-- | A type for foreign type errors
data ForeignError
  = ForeignError String
  | TypeMismatch String String
  | ErrorAtIndex Int ForeignError
  | ErrorAtProperty String ForeignError
  | JSONError String

derive instance eqForeignError :: Eq ForeignError
derive instance ordForeignError :: Ord ForeignError

instance showForeignError :: Show ForeignError where
  show (ForeignError msg) = "(ForeignError " <> msg <> ")"
  show (ErrorAtIndex i e) = "(ErrorAtIndex " <> show i <> " " <> show e <> ")"
  show (ErrorAtProperty prop e) = "(ErrorAtProperty " <> show prop <> " " <> show e <> ")"
  show (JSONError s) = "(JSONError " <> show s <> ")"
  show (TypeMismatch exps act) = "(TypeMismatch " <> show exps <> " " <> show act <> ")"

-- | A type for accumulating multiple `ForeignError`s.
type MultipleErrors = NonEmptyList ForeignError

renderForeignError :: ForeignError -> String
renderForeignError (ForeignError msg) = msg
renderForeignError (ErrorAtIndex i e) = "Error at array index " <> show i <> ": " <> show e
renderForeignError (ErrorAtProperty prop e) = "Error at property " <> show prop <> ": " <> show e
renderForeignError (JSONError s) = "JSON error: " <> s
renderForeignError (TypeMismatch exp act) = "Type mismatch: expected " <> exp <> ", found " <> act

-- | An error monad, used in this library to encode possible failures when
-- | dealing with foreign data.
type F a = Except MultipleErrors a

foreign import parseJSONImpl :: forall r. Fn3 (String -> r) (Foreign -> r) String r

-- | Attempt to parse a JSON string, returning the result as foreign data.
parseJSON :: String -> F Foreign
parseJSON json = runFn3 parseJSONImpl (fail <<< JSONError) pure json

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
unsafeReadTagged tag value
  | tagOf value == tag = pure (unsafeFromForeign value)
  | otherwise = fail $ TypeMismatch tag (tagOf value)

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
readChar value = mapExcept (either (const error) fromString) (readString value)
  where
  fromString = maybe error pure <<< toChar
  error = Left $ NEL.singleton $ TypeMismatch "Char" (tagOf value)

-- | Attempt to coerce a foreign value to a `Boolean`.
readBoolean :: Foreign -> F Boolean
readBoolean = unsafeReadTagged "Boolean"

-- | Attempt to coerce a foreign value to a `Number`.
readNumber :: Foreign -> F Number
readNumber = unsafeReadTagged "Number"

-- | Attempt to coerce a foreign value to an `Int`.
readInt :: Foreign -> F Int
readInt value = mapExcept (either (const error) fromNumber) (readNumber value)
  where
  fromNumber = maybe error pure <<< Int.fromNumber
  error = Left $ NEL.singleton $ TypeMismatch "Int" (tagOf value)

-- | Attempt to coerce a foreign value to an array.
readArray :: Foreign -> F (Array Foreign)
readArray value
  | isArray value = pure $ unsafeFromForeign value
  | otherwise = fail $ TypeMismatch "array" (tagOf value)

-- | Throws a failure error in `F`.
fail :: forall a. ForeignError -> F a
fail = throwError <<< NEL.singleton

-- | A key/value pair for an object to be written as a `Foreign` value.
newtype Prop = Prop { key :: String, value :: Foreign }

-- | Constructs a JavaScript `Object` value (typed as `Foreign`) from an array
-- | of `Prop`s.
foreign import writeObject :: Array Prop -> Foreign
