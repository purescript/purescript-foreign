module Example.JSONArrays where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Data.Foreign (F)
import Data.Foreign.Class (readJSON)

main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ runExcept $ readJSON """["hello", "world"]""" :: F (Array String)
  logShow $ runExcept $ readJSON """[1, 2, 3, 4]""" :: F (Array Number)
