module Example.SimpleTypes where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Data.Foreign (readString, readNumber, readBoolean)

import Example.Util.Value (foreignValue)

-- Parsing of the simple JSON String, Number and Boolean types is provided
-- out of the box.
main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ runExcept $
    readString =<< foreignValue "\"a JSON string\""
  logShow $ runExcept $
    readNumber =<< foreignValue "42"
  logShow $ runExcept $
    readBoolean =<< foreignValue "true"
