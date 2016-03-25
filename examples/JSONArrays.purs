module Example.JSONArrays where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)

import Data.Foreign (F)
import Data.Foreign.Class (readJSON)

main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ readJSON """["hello", "world"]""" :: F (Array String)
  logShow $ readJSON """[1, 2, 3, 4]""" :: F (Array Number)
