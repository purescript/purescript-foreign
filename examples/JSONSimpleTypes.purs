module Example.JSONSimpleTypes where

import Prelude

import Data.Foreign
import Data.Foreign.Class
import Control.Monad.Eff.Console

-- Parsing of the simple JSON String, Number and Boolean types is provided
-- out of the box.
main = do
  print $ readJSON "\"a JSON string\"" :: F String
  print $ readJSON "42" :: F Number
  print $ readJSON "true" :: F Boolean
