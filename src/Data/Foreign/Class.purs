module Data.Foreign.Class
  ( IsForeign
  
  , read
  , readJSON
  
  , readProp
  ) where
      
import Data.Foreign
import Data.Foreign.Index
import Data.Foreign.Null
import Data.Foreign.Undefined
import Data.Foreign.NullOrUndefined
import Data.Traversable (traverse)
import Data.Either

class IsForeign a where
  read :: Foreign -> F a
  
instance stringIsForeign :: IsForeign String where
  read = readString
  
instance booleanIsForeign :: IsForeign Boolean where
  read = readBoolean
  
instance numberIsForeign :: IsForeign Number where
  read = readNumber
  
instance arrayIsForeign :: (IsForeign a) => IsForeign [a] where
  read value = readArray value >>= traverse read
  
instance nullIsForeign :: (IsForeign a) => IsForeign (Null a) where
  read = readNull read
  
instance undefinedIsForeign :: (IsForeign a) => IsForeign (Undefined a) where
  read = readUndefined read
  
instance nullOrUndefinedIsForeign :: (IsForeign a) => IsForeign (NullOrUndefined a) where
  read = readNullOrUndefined read
  
readJSON :: forall a. (IsForeign a) => String -> F a
readJSON json = parseJSON json >>= read

readProp :: forall a i. (IsForeign a, Index i) => i -> Foreign -> F a
readProp prop value = value ! prop >>= read