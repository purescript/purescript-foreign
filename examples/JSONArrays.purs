module JSONArrays where

import Data.Array
import Data.Either
import Data.Foreign
import Data.Foreign.Class
import Control.Monad.Eff
import Debug.Trace

main = do
  print $ readJSON "[\"hello\", \"world\"]" :: F [String]
  print $ readJSON "[1, 2, 3, 4]" :: F [Number]
