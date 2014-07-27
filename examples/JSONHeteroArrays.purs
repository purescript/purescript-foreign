module JSONHeteroArrays where

import Prelude
import Data.Array
import Data.Tuple
import Data.Either
import Data.Foreign
import Control.Monad.Eff

main = do

  Debug.Trace.trace $ case parseJSON "[\"hello\", 12]" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right result -> show $ result :: Tuple String Number
