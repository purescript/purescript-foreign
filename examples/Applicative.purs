module Applicative where

import Prelude
import Data.Array
import Data.Either
import Data.Foreign
import Control.Monad.Eff

data Point = Point Number Number Number

instance readPoint :: ReadForeign Point where
  read = Point <$> prop "x"
               <*> prop "y"
               <*> prop "z"

main = do

  Debug.Trace.trace $ case parseJSON "{ \"x\": 1, \"y\": 2, \"z\": 3 }" of
    Left err -> "Error parsing JSON:\n" ++ err
    Right (Point x y z) -> show [x, y, z]
