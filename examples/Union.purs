module Example.Union where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)

import Data.Foreign (F)
import Data.Foreign.Class (class IsForeign, readJSON, readProp)

data StringList = Nil | Cons String StringList

instance showStringList :: Show StringList where
  show Nil = "Nil"
  show (Cons s l) = "(Cons " <> show s <> " " <> show l <> ")"

instance stringListIsForeign :: IsForeign StringList where
  read value = do
    nil <- readProp "nil" value
    if nil
      then pure Nil
      else Cons <$> readProp "head" value
                <*> readProp "tail" value

main :: Eff (console :: CONSOLE) Unit
main = do

  logShow $ readJSON """
    { "nil": false
    , "head": "Hello"
    , "tail":
      { "nil": false
      , "head": "World"
      , "tail":
        { "nil": true }
      }
    }
    """ :: F StringList

  logShow $ readJSON """
    { "nil": false
    , "head": "Hello"
    , "tail":
      { "nil": false
      , "head": 0
      , "tail":
        { "nil": true }
      }
    }
    """ :: F StringList
