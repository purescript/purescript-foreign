module Example.Arrays where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Foreign (readArray, readNumber, readString)
import Data.Traversable (traverse)

import Example.Util.Value (foreignValue)

main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ runExcept $
    traverse readString =<< readArray =<< foreignValue """["hello", "world"]"""
  logShow $ runExcept $
    traverse readNumber =<< readArray =<< foreignValue """[1, 2, 3, 4]"""
