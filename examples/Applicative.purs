module Example.Applicative where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Foreign (F, Foreign, readNumber)
import Foreign.Index ((!))

import Example.Util.Value (foreignValue)

data Point = Point Number Number Number

instance showPoint :: Show Point where
  show (Point x y z) = "(Point " <> show [x, y, z] <> ")"

readPoint :: Foreign -> F Point
readPoint value = do
  Point
    <$> (value ! "x" >>= readNumber)
    <*> (value ! "y" >>= readNumber)
    <*> (value ! "z" >>= readNumber)

main :: Eff (console :: CONSOLE) Unit
main =
  logShow $ runExcept $
    readPoint =<< foreignValue """{ "x": 1, "y": 2, "z": 3 }"""
