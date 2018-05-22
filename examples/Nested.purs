module Example.Nested where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Foreign (F, Foreign, readNumber, readString)
import Foreign.Index ((!))

import Example.Util.Value (foreignValue)

data Foo = Foo Bar Baz

data Bar = Bar String

data Baz = Baz Number

instance showFoo :: Show Foo where
  show (Foo bar baz) = "(Foo " <> show bar <> " " <> show baz <> ")"

instance showBar :: Show Bar where
  show (Bar s) = "(Bar " <> show s <> ")"

instance showBaz :: Show Baz where
  show (Baz n) = "(Baz " <> show n <> ")"

readFoo :: Foreign -> F Foo
readFoo value = do
  s <- value ! "foo" ! "bar" >>= readString
  n <- value ! "foo" ! "baz" >>= readNumber
  pure $ Foo (Bar s) (Baz n)

main :: Eff (console :: CONSOLE) Unit
main =
  logShow $ runExcept $
    readFoo =<< foreignValue """{ "foo": { "bar": "bar", "baz": 1 } }"""
