module Example.MaybeNullable where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Foreign (readBoolean, readNull)
import Data.Traversable (traverse)

import Example.Util.Value (foreignValue)

-- Parsing values that are allowed to null or undefined is possible by
-- using Maybe types.
main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ runExcept $
    traverse readBoolean =<< readNull =<< foreignValue "null"
  logShow $ runExcept $
    traverse readBoolean =<< readNull =<< foreignValue "true"
