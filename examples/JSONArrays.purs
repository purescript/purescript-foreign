module Example.JSONArrays where

import Data.Foreign
import Data.Foreign.Class

main = do
  Console.print $ readJSON """["hello", "world"]""" :: F [String]
  Console.print $ readJSON """[1, 2, 3, 4]""" :: F [Number]
