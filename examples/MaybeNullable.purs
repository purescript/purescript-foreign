module Example.MaybeNullable where

import Prelude

import Effect (Effect)
import Effect.Console (logShow)
import Control.Monad.Except (runExcept)

import Foreign (readBoolean, readNull)
import Data.Traversable (traverse)

import Example.Util.Value (foreignValue)

-- Parsing values that are allowed to null or undefined is possible by
-- using Maybe types.
main :: Effect Unit
main = do
  logShow $ runExcept $
    traverse readBoolean =<< readNull =<< foreignValue "null"
  logShow $ runExcept $
    traverse readBoolean =<< readNull =<< foreignValue "true"
