module JSONSimpleTypes where

import Prelude
import Data.Either
import Data.JSON
import Control.Monad.Eff

-- Parsing of the simple JSON String, Number and Boolean types is provided
-- out of the box.
main = do

  Debug.Trace.trace $ case parseJSON "\"a JSON string\"" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> result :: String
    
  Debug.Trace.trace $ case parseJSON "42" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: Number
    
  Debug.Trace.trace $ case parseJSON "true" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: Boolean
