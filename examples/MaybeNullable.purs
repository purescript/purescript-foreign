module Example.MaybeNullable where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)

import Data.Foreign (F)
import Data.Foreign.Class (readJSON)
import Data.Foreign.Null (Null, unNull)

-- Parsing values that are allowed to null or undefined is possible by
-- using Maybe types.
main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ unNull <$> readJSON "null" :: F (Null Boolean)
  logShow $ unNull <$> readJSON "true" :: F (Null Boolean)
