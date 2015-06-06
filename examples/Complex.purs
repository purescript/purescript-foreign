module Example.Complex where

import Prelude

import Data.Foreign
import Data.Foreign.Class
import Data.Foreign.NullOrUndefined
import Data.Maybe (Maybe())

data SomeObject = SomeObject { foo :: String
                             , bar :: Boolean
                             , baz :: Number
                             , list :: [ListItem] }

instance showSomeObject :: Show SomeObject where
  show (SomeObject o) =
    "SomeObject { foo: " ++ show o.foo ++
    ", bar: " ++ show o.bar ++
    ", baz: " ++ show o.baz ++
    ", list: " ++ show o.list ++
    " }"

instance objectIsForeign :: IsForeign SomeObject where
  read value = do
    foo  <- readProp "foo"  value
    bar  <- readProp "bar"  value
    baz  <- readProp "baz"  value
    list <- readProp "list" value
    return $ SomeObject { foo: foo, bar: bar, baz: baz, list: list }

data ListItem = ListItem { x :: Number
                         , y :: Number
                         , z :: Maybe Number }

instance showListItem :: Show ListItem where
  show (ListItem o) =
    "ListItem { x: " ++ show o.x ++
    ", y: " ++ show o.y ++
    ", z: " ++ show o.z ++
    " }"

instance listItemIsForeign :: IsForeign ListItem where
  read value = do
    x <- readProp "x" value
    y <- readProp "y" value
    z <- runNullOrUndefined <$> readProp "z" value
    return $ ListItem { x: x, y: y, z: z }

main = do
  let json = """{"foo":"hello","bar":true,"baz":1,"list":[{"x":1,"y":2},{"x":3,"y":4,"z":999}]}"""
  Console.print $ readJSON json :: F SomeObject
