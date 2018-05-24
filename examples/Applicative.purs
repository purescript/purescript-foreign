module Example.Applicative where

import Prelude

import Control.Monad.Except (runExcept)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (F, Foreign, readNumber)
import Foreign.Index ((!))

data Point = Point Number Number Number

instance showPoint :: Show Point where
  show (Point x y z) = "(Point " <> show [x, y, z] <> ")"

readPoint :: Foreign -> F Point
readPoint value = do
  Point
    <$> (value ! "x" >>= readNumber)
    <*> (value ! "y" >>= readNumber)
    <*> (value ! "z" >>= readNumber)

main :: Effect Unit
main =
  logShow $ runExcept $
    readPoint =<< foreignValue """{ "x": 1, "y": 2, "z": 3 }"""
