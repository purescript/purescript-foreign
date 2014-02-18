module Complex where

  import Prelude
  import Data.JSON
  import Either
  import Monad
  import Maybe
  import Eff
  
  foreign import showUnsafe "function showUnsafe (obj) { \
                            \  return JSON.stringify(obj); \
                            \}" :: forall a. a -> String
  
  data Object = Object { foo :: String
                       , bar :: Boolean
                       , baz :: Number
                       , list :: [ListItem] }
                       
  data ListItem = ListItem { x :: Number
                           , y :: Number
                           , z :: Maybe Number }
                           
  instance Data.JSON.ReadJSON ListItem where
    readJSON = do
      x <- readJSONProp "x"
      y <- readJSONProp "y"
      z <- readJSONProp "z"
      return $ ListItem { x: x, y: y, z: z }
  
  instance Data.JSON.ReadJSON Object where
    readJSON = do
      foo <- readJSONProp "foo"
      bar <- readJSONProp "bar"
      baz <- readJSONProp "baz"
      list <- readJSONProp "list"
      return $ Object { foo: foo, bar: bar, baz: baz, list: list }
      
  main = do
  
    let json = "{\"foo\":\"hello\",\"bar\":true,\"baz\":1,\"list\":[{\"x\":1,\"y\":2},{\"x\":3,\"y\":4,\"z\":999}]}" 
    Trace.trace case parseJSON json of
      Left err -> "Error parsing JSON:\n" ++ err
      Right (Object result) -> showUnsafe result
