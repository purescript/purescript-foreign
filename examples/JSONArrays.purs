module JSONArrays where

import Prelude
import Data.Array
import Data.Either
import Data.JSON
import Control.Monad.Eff

main = do

  Debug.Trace.trace $ case parseJSON "[\"hello\", \"world\"]" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: [String]
    
  Debug.Trace.trace $ case parseJSON "[1, 2, 3, 4]" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: [Number]
