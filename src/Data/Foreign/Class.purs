-- | This module defines a type class for reading foreign values.

module Data.Foreign.Class
  ( class IsForeign
  , read
  , readJSON
  , readWith
  , readProp
  , class AsForeign
  , write
  , writeProp, (.=)
  , readEitherR
  , readEitherL
  ) where

import Prelude

import Control.Alt ((<|>))
import Control.Monad.Except (Except, mapExcept)

import Data.Array (range, zipWith, length)
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Foreign (F, Foreign, MultipleErrors, ForeignError(..), Prop(..), toForeign, parseJSON, readArray, readInt, readNumber, readBoolean, readChar, readString)
import Data.Foreign.Index (class Index, errorAt, (!))
import Data.Foreign.Null (Null(..), readNull, writeNull)
import Data.Foreign.NullOrUndefined (NullOrUndefined(..), readNullOrUndefined)
import Data.Foreign.Undefined (Undefined(..), readUndefined, writeUndefined)
import Data.Maybe (maybe)
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

instance arrayIsForeign :: IsForeign a => IsForeign (Array a) where
  read = readArray >=> readElements
    where
    readElements :: Array Foreign -> F (Array a)
    readElements arr = sequence (zipWith readElement (range zero (length arr)) arr)

    readElement :: Int -> Foreign -> F a
    readElement i value = readWith (map (ErrorAtIndex i)) value

instance nullIsForeign :: IsForeign a => IsForeign (Null a) where
  read = readNull read

instance undefinedIsForeign :: IsForeign a => IsForeign (Undefined a) where
  read = readUndefined read

instance nullOrUndefinedIsForeign :: IsForeign a => IsForeign (NullOrUndefined a) where
  read = readNullOrUndefined read

-- | Attempt to read a data structure from a JSON string
readJSON :: forall a. IsForeign a => String -> F a
readJSON json = parseJSON json >>= read

-- | Attempt to read a foreign value, handling errors using the specified function
readWith :: forall a e. IsForeign a => (MultipleErrors -> e) -> Foreign -> Except e a
readWith f = mapExcept (lmap f) <<< read

-- | Attempt to read a property of a foreign value at the specified index
readProp :: forall a i. (IsForeign a, Index i) => i -> Foreign -> F a
readProp prop value = value ! prop >>= readWith (map (errorAt prop))

-- | A type class to convert to a `Foreign` value.
-- |
-- | Instances are provided for standard data structures.
class AsForeign a where
  write :: a -> Foreign

instance foreignAsForeign :: AsForeign Foreign where
  write = id

instance stringAsForeign :: AsForeign String where
  write = toForeign

instance charAsForeign :: AsForeign Char where
  write = toForeign

instance booleanAsForeign :: AsForeign Boolean where
  write = toForeign

instance numberAsForeign :: AsForeign Number where
  write = toForeign

instance intAsForeign :: AsForeign Int where
  write = toForeign

instance arrayAsForeign :: AsForeign a => AsForeign (Array a) where
  write = toForeign <<< map write

instance nullAsForeign :: AsForeign a => AsForeign (Null a) where
  write (Null a) = maybe writeNull write a

instance undefinedAsForeign :: AsForeign a => AsForeign (Undefined a) where
  write (Undefined a) = maybe writeUndefined write a

instance nullOrUndefinedAsForeign :: AsForeign a => AsForeign (NullOrUndefined a) where
  write (NullOrUndefined a) = write (Null a)

infixl 8 writeProp as .=

writeProp :: forall a. AsForeign a => String -> a -> Prop
writeProp k v = Prop { key: k, value: write v }

-- | Attempt to read a value that can be either one thing or another. This
-- | implementation is right biased.
readEitherR :: forall l r. (IsForeign l, IsForeign r) => Foreign -> F (Either l r)
readEitherR value = Right <$> read value <|> Left <$> read value

-- | Attempt to read a value that can be either one thing or another. This
-- | implementation is left biased.
readEitherL :: forall l r. (IsForeign l, IsForeign r) => Foreign -> F (Either l r)
readEitherL value = Left <$> read value <|> Right <$> read value
