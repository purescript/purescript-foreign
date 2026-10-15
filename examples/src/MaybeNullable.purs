module Example.MaybeNullable where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (readBoolean, readNull)

-- Parsing values that are allowed to null or undefined is possible by
-- using Maybe types.
main :: Effect Unit
main = do
  logShow $ runExcept $
    traverse readBoolean =<< readNull =<< foreignValue "null"
  logShow $ runExcept $
    traverse readBoolean =<< readNull =<< foreignValue "true"
