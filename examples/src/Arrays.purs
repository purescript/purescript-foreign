module Example.Arrays where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (readArray, readNumber, readString)

main :: Effect Unit
main = do
  logShow $ runExcept $
    traverse readString =<< readArray =<< foreignValue """["hello", "world"]"""
  logShow $ runExcept $
    traverse readNumber =<< readArray =<< foreignValue """[1, 2, 3, 4]"""
