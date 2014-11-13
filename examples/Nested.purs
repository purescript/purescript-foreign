module Nested where

import Data.Either
import Data.Foreign
import Data.Foreign.Index
import Data.Foreign.Class
import Control.Monad.Eff
import Control.Bind
import Debug.Trace

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
  print $ readJSON "{ \"foo\": { \"bar\": \"bar\", \"baz\": 1 } }" :: F Foo
