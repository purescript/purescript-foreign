module Example.Objects where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Foreign (F, Foreign, readNumber)
import Foreign.Index ((!))

import Example.Util.Value (foreignValue)

newtype Point = Point { x :: Number, y :: Number }

instance showPoint :: Show Point where
  show (Point { x, y }) =
    "(Point { x: " <> show x <> ", y: " <> show y <> " })"

readPoint :: Foreign -> F Point
readPoint value = do
  x <- value ! "x" >>= readNumber
  y <- value ! "y" >>= readNumber
  pure $ Point { x, y }

main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ runExcept $
    readPoint =<< foreignValue """{ "x": 1, "y": 2 }"""
