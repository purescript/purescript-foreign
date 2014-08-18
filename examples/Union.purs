module Union where

import Data.Either
import Data.Foreign
import Data.Foreign.Index
import Data.Foreign.Class
import Control.Monad.Eff
import Control.Bind
import Debug.Trace

data StringList = Nil | Cons String StringList

instance showStringList :: Show StringList where
  show Nil = "Nil"
  show (Cons s l) = "Cons " ++ show s ++ " (" ++ show l ++ ")" 

instance stringListIsForeign :: IsForeign StringList where
  read value = do
    nil <- readProp "nil" value
    if nil
      then return Nil
      else Cons <$> readProp "head" value 
                <*> readProp "tail" value

main = do
  print $ readJSON "{ \"nil\": false \
                   \, \"head\": \"Hello\"\
                   \, \"tail\": \
                   \  { \"nil\": false\
                   \  , \"head\": \"World\"\
                   \  , \"tail\": \
                   \    { \"nil\": true } \
                   \  } \
                   \}" :: F StringList
  print $ readJSON "{ \"nil\": false \
                   \, \"head\": \"Hello\"\
                   \, \"tail\": \
                   \  { \"nil\": false\
                   \  , \"head\": 0\
                   \  , \"tail\": \
                   \    { \"nil\": true } \
                   \  } \
                   \}" :: F StringList
