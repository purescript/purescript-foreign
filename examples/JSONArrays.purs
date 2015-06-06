module Example.JSONArrays where

import Prelude

import Data.Foreign
import Data.Foreign.Class

main = do
  Console.print $ readJSON """["hello", "world"]""" :: F (Array String)
  Console.print $ readJSON """[1, 2, 3, 4]""" :: F (Array Number)
