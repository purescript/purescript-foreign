module Main where

  import Prelude
  import Either
  import JSON 
  import Monad 
  
  foreign import toJSON "function toJSON (obj) { return obj; }" :: forall a. a -> JSON
  
  showUnsafe :: forall a. a -> String
  showUnsafe = showJSON <<< toJSON
  
  class ReadJSON a where
    readJSON :: JSON -> Either String a
    -- readJSON :: JSONParser -- bug, type synoym here doesn't work
    
  instance ReadJSON String where
    readJSON = str
    
  instance ReadJSON Number where
    readJSON = num
    
  instance ReadJSON Boolean where
    readJSON = bool
    
  instance (ReadJSON a) => ReadJSON [a] where
    readJSON j = (arr j) >>= mapM readJSON
    
  readJSONProp :: forall a. (ReadJSON a) => String -> JSONParser a
  readJSONProp p j = (prop p j) >>= readJSON
  
  data Object = Object { foo :: String, bar :: Boolean, baz :: Number, list :: [ListItem] }
  data ListItem = ListItem { x :: Number, y :: Number }
  
  instance ReadJSON ListItem where
    readJSON json = do
      x <- readJSONProp "x" json
      y <- readJSONProp "y" json
      return $ ListItem { x: x, y: y }
  
  instance ReadJSON Object where
    readJSON json = do
      foo <- readJSONProp "foo" json
      bar <- readJSONProp "bar" json
      baz <- readJSONProp "baz" json
      list <- readJSONProp "list" json
      return $ Object { foo: foo, bar: bar, baz: baz, list: list }
      
  main = do
    let obj = fromString "{\"foo\":\"hello\",\"bar\":true,\"baz\":1,\"list\":[{\"x\":1,\"y\":2},{\"x\":3,\"y\":4}]}" 
    case obj of
      Left err -> Trace.print $ "Error parsing: " ++ err
      Right obj -> case readJSON obj of
        Left err -> Trace.print err
        Right (Object result) -> Trace.print $ showUnsafe result
