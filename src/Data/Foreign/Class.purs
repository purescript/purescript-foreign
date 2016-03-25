-- | This module defines a type class for reading foreign values.

module Data.Foreign.Class
  ( class IsForeign
  , read
  , readJSON
  , readWith
  , readProp
  ) where

import Prelude

import Data.Array (range, zipWith, length)
import Data.Either (Either(..), either)
import Data.Foreign (F, Foreign, ForeignError(..), parseJSON, readArray, readInt, readNumber, readBoolean, readChar, readString)
import Data.Foreign.Index (class Index, errorAt, (!))
import Data.Foreign.Null (Null, readNull)
import Data.Foreign.NullOrUndefined (NullOrUndefined, readNullOrUndefined)
import Data.Foreign.Undefined (Undefined, readUndefined)
import Data.Traversable (sequence)

-- | A type class instance for this class can be written for a type if it
-- | is possible to attempt to _safely_ coerce a `Foreign` value to that
-- | type.
-- |
-- | Instances are provided for standard data structures, and the `F` monad
-- | can be used to construct instances for new data structures.
class IsForeign a where
  read :: Foreign -> F a

instance foreignIsForeign :: IsForeign Foreign where
  read = pure

instance stringIsForeign :: IsForeign String where
  read = readString

instance charIsForeign :: IsForeign Char where
  read = readChar

instance booleanIsForeign :: IsForeign Boolean where
  read = readBoolean

instance numberIsForeign :: IsForeign Number where
  read = readNumber

instance intIsForeign :: IsForeign Int where
  read = readInt

instance arrayIsForeign :: (IsForeign a) => IsForeign (Array a) where
  read value = readArray value >>= readElements
    where
    readElements :: Array Foreign -> F (Array a)
    readElements arr = sequence (zipWith readElement (range zero (length arr)) arr)

    readElement :: Int -> Foreign -> F a
    readElement i value = readWith (ErrorAtIndex i) value

instance nullIsForeign :: (IsForeign a) => IsForeign (Null a) where
  read = readNull read

instance undefinedIsForeign :: (IsForeign a) => IsForeign (Undefined a) where
  read = readUndefined read

instance nullOrUndefinedIsForeign :: (IsForeign a) => IsForeign (NullOrUndefined a) where
  read = readNullOrUndefined read

-- | Attempt to read a data structure from a JSON string
readJSON :: forall a. (IsForeign a) => String -> F a
readJSON json = parseJSON json >>= read

-- | Attempt to read a foreign value, handling errors using the specified function
readWith :: forall a e. (IsForeign a) => (ForeignError -> e) -> Foreign -> Either e a
readWith f value = either (Left <<< f) Right (read value)

-- | Attempt to read a property of a foreign value at the specified index
readProp :: forall a i. (IsForeign a, Index i) => i -> Foreign -> F a
readProp prop value = value ! prop >>= readWith (errorAt prop)
