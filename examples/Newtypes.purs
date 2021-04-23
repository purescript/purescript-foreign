module Example.Newtypes where

import Prelude
import Control.Monad.Except (runExcept)
import Data.Maybe (Maybe)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (logShow)
import Example.Util.Value (foreignValue)
import Foreign (F, Foreign, readNullOrUndefined, readString)
import Foreign.Index ((!))

newtype Email
  = Email String

derive newtype instance showEmail :: Show Email

type SomeObject
  = { foo :: String
    , bar :: Maybe String
    , baz :: Email
    , duh :: Maybe Email
    }

readObject :: Foreign -> F SomeObject
readObject value = do
  foo <- value ! "foo" >>= readString
  bar <- value ! "bar" >>= readNullOrUndefined >>= traverse readString
  baz <- value ! "baz" >>= readString <#> Email
  duh <- value ! "duh" >>= readNullOrUndefined >>= traverse readString <#> map Email
  pure { foo, bar, baz, duh }

main :: Effect Unit
main = do
  logShow $ runExcept
    $ readObject
    =<< foreignValue """{ "foo": "a@b.org", "bar": null, "baz": "c@d.net" }"""
