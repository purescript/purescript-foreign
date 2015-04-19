module Example.JSONSimpleTypes where

import Data.Foreign
import Data.Foreign.Class

-- Parsing of the simple JSON String, Number and Boolean types is provided
-- out of the box.
main = do
  Console.print $ readJSON "\"a JSON string\"" :: F String
  Console.print $ readJSON "42" :: F Number
  Console.print $ readJSON "true" :: F Boolean
