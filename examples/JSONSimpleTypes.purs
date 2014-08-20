module JSONSimpleTypes where

import Data.Either
import Data.Foreign
import Data.Foreign.Class
import Control.Monad.Eff
import Debug.Trace

-- Parsing of the simple JSON String, Number and Boolean types is provided
-- out of the box.
main = do
  print $ readJSON "\"a JSON string\"" :: F String
  print $ readJSON "42" :: F Number 
  print $ readJSON "true" :: F Boolean
