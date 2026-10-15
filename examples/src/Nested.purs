module Example.Nested where

import Prelude

import Control.Monad.Except (runExcept)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (F, Foreign, readNumber, readString)
import Foreign.Index ((!))

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

main :: Effect Unit
main =
  logShow $ runExcept $
    readFoo =<< foreignValue """{ "foo": { "bar": "bar", "baz": 1 } }"""
