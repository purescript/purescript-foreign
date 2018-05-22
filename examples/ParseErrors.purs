module Example.ParseErrors where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (F, Foreign, readArray, readBoolean, readNumber, readString)
import Foreign.Index ((!))

newtype Point = Point { x :: Number, y :: Number }

instance showPoint :: Show Point where
  show (Point o) = "(Point { x: " <> show o.x <> ", y: " <> show o.y <> " })"

readPoint :: Foreign -> F Point
readPoint value = do
  x <- value ! "x" >>= readNumber
  y <- value ! "y" >>= readNumber
  pure $ Point { x: x, y: y }

main :: Effect Unit
main = do

  -- When trying to parse invalid JSON we catch an exception from
  -- `JSON.parse` and pass it on.
  logShow $ runExcept $
    readString =<< foreignValue "not even JSON"

  -- When attempting to coerce one type to another we get an error.
  logShow $ runExcept $
    readBoolean =<< foreignValue "26"

  -- When parsing fails in an array, we're told at which index the value that
  -- failed to parse was, along with the reason the value didn't parse.
  logShow $ runExcept $
    traverse readBoolean =<< readArray =<< foreignValue "[1, true, 3]"

  -- When parsing fails in an object, we're the name of the property which
  -- failed to parse was, along with the reason the value didn't parse.
  logShow $ runExcept $
    readPoint =<< foreignValue """{ "x": 1, "y": false }"""
