module Main where

  import Prelude
  import Either
  import JSON 
  import Monad 
  import Maybe 
  
  foreign import toJSON "function toJSON (obj) { return obj; }" :: forall a. a -> JSON
  
  foreign import maybeJSON "function maybeJSON (value) { \
                           \  return value === undefined || value === null ? _ps.Maybe.Nothing : _ps.Maybe.Just(value); \
                           \}" :: forall a. JSON -> Maybe JSON
  
  showUnsafe :: forall a. a -> String
  showUnsafe = showJSON <<< toJSON
  
  class ReadJSON a where
    readJSON :: JSONParser a
    
  instance ReadJSON String where
    readJSON = str
    
  instance ReadJSON Number where
    readJSON = num
    
  instance ReadJSON Boolean where
    readJSON = bool
    
  instance (ReadJSON a) => ReadJSON [a] where
    readJSON j = (arr j) >>= mapM readJSON
    
  instance (ReadJSON a) => ReadJSON (Maybe a) where
    readJSON j =
      case maybeJSON j of 
        Just x -> readJSON x >>= return <<< Just
        Nothing -> Right Nothing
    
  readJSONProp :: forall a. (ReadJSON a) => String -> JSONParser a
  readJSONProp p j = (prop p j) >>= readJSON
  
  data Object = Object { foo :: String
                       , bar :: Boolean
                       , baz :: Number
                       , list :: [ListItem] }
                       
  data ListItem = ListItem { x :: Number
                           , y :: Number
                           , z :: Maybe Number }
                           
  instance ReadJSON ListItem where
    readJSON json = do
      x <- readJSONProp "x" json
      y <- readJSONProp "y" json
      z <- readJSONProp "z" json
      return $ ListItem { x: x, y: y, z: z }
  
  instance ReadJSON Object where
    readJSON json = do
      foo <- readJSONProp "foo" json
      bar <- readJSONProp "bar" json
      baz <- readJSONProp "baz" json
      list <- readJSONProp "list" json
      return $ Object { foo: foo, bar: bar, baz: baz, list: list }
      
  main = do
    let obj = fromString "{\"foo\":\"hello\",\"bar\":true,\"baz\":1,\"list\":[{\"x\":1,\"y\":2},{\"x\":3,\"y\":4,\"z\":999}]}" 
    case obj of
      Left err -> Trace.print $ "Error parsing: " ++ err
      Right obj -> case readJSON obj of
        Left err -> Trace.print err
        Right (Object result) -> Trace.print $ showUnsafe result
