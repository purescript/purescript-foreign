module Example.Complex where

import Prelude

import Control.Monad.Except (Except, runExcept)
import Data.List.NonEmpty (NonEmptyList)
import Data.Maybe (Maybe)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (Foreign, ForeignError, readArray, readBoolean, readNumber, readString, readNullOrUndefined)
import Foreign.Index ((!))

type SomeObject =
  { foo :: String
  , bar :: Boolean
  , baz :: Number
  , list :: Array ListItem
  }

readSomeObject :: Foreign -> Except (NonEmptyList ForeignError) SomeObject
readSomeObject value = do
  foo <- value ! "foo" >>= readString
  bar <- value ! "bar" >>= readBoolean
  baz <- value ! "baz" >>= readNumber
  list <- value ! "list" >>= readArray >>= traverse readListItem
  pure { foo, bar, baz, list }

type ListItem =
  { x :: Number
  , y :: Number
  , z :: Maybe Number
  }

readListItem :: Foreign -> Except (NonEmptyList ForeignError) ListItem
readListItem value = do
  x <- value ! "x" >>= readNumber
  y <- value ! "y" >>= readNumber
  z <- value ! "z" >>= readNullOrUndefined >>= traverse readNumber
  pure { x, y, z }

main :: Effect Unit
main = do
  let json = """{"foo":"hello","bar":true,"baz":1,"list":[{"x":1,"y":2},{"x":3,"y":4,"z":999}]}"""
  logShow $ runExcept $ readSomeObject =<< foreignValue json
