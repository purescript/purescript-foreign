module Example.Union where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Foreign (F, Foreign, readBoolean, readString)
import Foreign.Index ((!))

import Example.Util.Value (foreignValue)

data StringList = Nil | Cons String StringList

instance showStringList :: Show StringList where
  show Nil = "Nil"
  show (Cons s l) = "(Cons " <> show s <> " " <> show l <> ")"

readStringList :: Foreign -> F StringList
readStringList value =
  value ! "nil" >>=
    readBoolean >>=
      if _
      then pure Nil
      else
        Cons
          <$> (value ! "head" >>= readString)
          <*> (value ! "tail" >>= readStringList)

main :: Eff (console :: CONSOLE) Unit
main = do

  logShow $ runExcept $
    readStringList =<< foreignValue
      """
      { "nil": false
      , "head": "Hello"
      , "tail":
        { "nil": false
        , "head": "World"
        , "tail":
          { "nil": true }
        }
      }
      """

  logShow $ runExcept $
    readStringList =<< foreignValue
      """
      { "nil": false
      , "head": "Hello"
      , "tail":
        { "nil": false
        , "head": 0
        , "tail":
          { "nil": true }
        }
      }
      """
