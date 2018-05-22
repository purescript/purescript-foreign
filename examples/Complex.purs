module Example.Complex where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Foreign (F, Foreign, readArray, readBoolean, readNumber, readString, readNullOrUndefined)
import Foreign.Index ((!))
import Data.Traversable (traverse)
import Data.Maybe (Maybe)

import Example.Util.Value (foreignValue)

newtype SomeObject =
  SomeObject
    { foo :: String
    , bar :: Boolean
    , baz :: Number
    , list :: Array ListItem
    }

instance showSomeObject :: Show SomeObject where
  show (SomeObject o) =
    "(SomeObject { foo: " <> show o.foo <>
    ", bar: " <> show o.bar <>
    ", baz: " <> show o.baz <>
    ", list: " <> show o.list <>
    "})"

readSomeObject :: Foreign -> F SomeObject
readSomeObject value = do
  foo <- value ! "foo" >>= readString
  bar <- value ! "bar" >>= readBoolean
  baz <- value ! "baz" >>= readNumber
  list <- value ! "list" >>= readArray >>= traverse readListItem
  pure $ SomeObject { foo, bar, baz, list }

newtype ListItem =
  ListItem
    { x :: Number
    , y :: Number
    , z :: Maybe Number
    }

instance showListItem :: Show ListItem where
  show (ListItem o) =
    "(ListItem { x: " <> show o.x <>
    ", y: " <> show o.y <>
    ", z: " <> show o.z <>
    " })"

readListItem :: Foreign -> F ListItem
readListItem value = do
  x <- value ! "x" >>= readNumber
  y <- value ! "y" >>= readNumber
  z <- value ! "z" >>= readNullOrUndefined >>= traverse readNumber
  pure $ ListItem { x, y, z }

main :: Eff (console :: CONSOLE) Unit
main = do
  let json = """{"foo":"hello","bar":true,"baz":1,"list":[{"x":1,"y":2},{"x":3,"y":4,"z":999}]}"""
  logShow $ runExcept $ readSomeObject =<< foreignValue json
