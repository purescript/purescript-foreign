module Example.Nested where

import Control.Bind ((>=>))
import Data.Foreign
import Data.Foreign.Class
import Data.Foreign.Index

data Foo = Foo Bar Baz

data Bar = Bar String

data Baz = Baz Number

instance showFoo :: Show Foo where
  show (Foo bar baz) = "Foo (" ++ show bar ++ ") (" ++ show baz ++ ")"

instance showBar :: Show Bar where
  show (Bar s) = "Bar " ++ show s

instance showBaz :: Show Baz where
  show (Baz n) = "Baz " ++ show n

instance fooIsForeign :: IsForeign Foo where
  read value = do
    s <- value # prop "foo" >=> readProp "bar"
    n <- value # prop "foo" >=> readProp "baz"
    return $ Foo (Bar s) (Baz n)

main = do
  Console.print $ readJSON """{ "foo": { "bar": "bar", "baz": 1 } }""" :: F Foo
