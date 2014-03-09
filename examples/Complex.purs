module Complex where

import Prelude
import Data.Array
import Data.Either
import Data.Foreign
import Data.Maybe
import Control.Monad.Eff

foreign import showUnsafe
  "var showUnsafe = JSON.stringify;" :: forall a. a -> String

data Object = Object { foo :: String
                     , bar :: Boolean
                     , baz :: Number
                     , list :: [ListItem] }
                     
data ListItem = ListItem { x :: Number
                         , y :: Number
                         , z :: Maybe Number }
                         
instance readListItem :: ReadForeign ListItem where
  read = do
    x <- prop "x"
    y <- prop "y"
    z <- prop "z"
    return $ ListItem { x: x, y: y, z: z }

instance readObject :: ReadForeign Object where
  read = do
    foo <- prop "foo"
    bar <- prop "bar"
    baz <- prop "baz"
    list <- prop "list"
    return $ Object { foo: foo, bar: bar, baz: baz, list: list }
    
main = do

  let json = "{\"foo\":\"hello\",\"bar\":true,\"baz\":1,\"list\":[{\"x\":1,\"y\":2},{\"x\":3,\"y\":4,\"z\":999}]}" 
  Debug.Trace.trace case parseJSON json of
    Left err -> "Error parsing JSON:\n" ++ err
    Right (Object result) -> showUnsafe result
