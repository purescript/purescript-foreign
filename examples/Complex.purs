module Example.Complex where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)

import Data.Foreign (F)
import Data.Foreign.Class (class IsForeign, readJSON, readProp)
import Data.Foreign.NullOrUndefined (unNullOrUndefined)
import Data.Maybe (Maybe)

data SomeObject = SomeObject { foo :: String
                             , bar :: Boolean
                             , baz :: Number
                             , list :: Array ListItem }

instance showSomeObject :: Show SomeObject where
  show (SomeObject o) =
    "(SomeObject { foo: " <> show o.foo <>
    ", bar: " <> show o.bar <>
    ", baz: " <> show o.baz <>
    ", list: " <> show o.list <>
    " })"

instance objectIsForeign :: IsForeign SomeObject where
  read value = do
    foo  <- readProp "foo"  value
    bar  <- readProp "bar"  value
    baz  <- readProp "baz"  value
    list <- readProp "list" value
    pure $ SomeObject { foo: foo, bar: bar, baz: baz, list: list }

data ListItem = ListItem { x :: Number
                         , y :: Number
                         , z :: Maybe Number }

instance showListItem :: Show ListItem where
  show (ListItem o) =
    "(ListItem { x: " <> show o.x <>
    ", y: " <> show o.y <>
    ", z: " <> show o.z <>
    " })"

instance listItemIsForeign :: IsForeign ListItem where
  read value = do
    x <- readProp "x" value
    y <- readProp "y" value
    z <- unNullOrUndefined <$> readProp "z" value
    pure $ ListItem { x: x, y: y, z: z }

main :: Eff (console :: CONSOLE) Unit
main = do
  let json = """{"foo":"hello","bar":true,"baz":1,"list":[{"x":1,"y":2},{"x":3,"y":4,"z":999}]}"""
  logShow $ readJSON json :: F SomeObject
