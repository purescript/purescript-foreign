module Example.JSONArrays where

import Prelude

import Data.Foreign
import Data.Foreign.Class
import Control.Monad.Eff.Console

main = do
  print $ readJSON """["hello", "world"]""" :: F (Array String)
  print $ readJSON """[1, 2, 3, 4]""" :: F (Array Number)
