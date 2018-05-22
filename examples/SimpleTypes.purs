module Example.SimpleTypes where

import Prelude

import Control.Monad.Except (runExcept)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (readString, readNumber, readBoolean)

-- Parsing of the simple JSON String, Number and Boolean types is provided
-- out of the box.
main :: Effect Unit
main = do
  logShow $ runExcept $
    readString =<< foreignValue "\"a JSON string\""
  logShow $ runExcept $
    readNumber =<< foreignValue "42"
  logShow $ runExcept $
    readBoolean =<< foreignValue "true"
