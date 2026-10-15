module Example.Objects where

import Prelude

import Control.Monad.Except (Except, runExcept)
import Data.List.NonEmpty (NonEmptyList)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (Foreign, ForeignError, readNumber)
import Foreign.Index ((!))

type Point = { x :: Number, y :: Number }

readPoint :: Foreign -> Except (NonEmptyList ForeignError) Point
readPoint value = do
  x <- value ! "x" >>= readNumber
  y <- value ! "y" >>= readNumber
  pure { x, y }

main :: Effect Unit
main = do
  logShow $ runExcept $
    readPoint =<< foreignValue """{ "x": 1, "y": 2 }"""
