module MaybeNullable where

import Prelude
import Data.Either
import Data.JSON
import Data.Maybe
import Control.Monad.Eff

-- Parsing values that are allowed to null or undefined is possible by 
-- using Maybe types.
main = do

  Debug.Trace.trace $ case parseJSON "null" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: Maybe Boolean
    
  Debug.Trace.trace $ case parseJSON "true" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: Maybe Boolean
