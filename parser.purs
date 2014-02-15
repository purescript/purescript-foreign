module JSON where

  import Prelude
  import Either
  import Monad
  import Maybe
  import Arrays
  import Tuples
  
  foreign import data JSON :: *
  
  foreign import fromString "function fromString (str) { \
                            \  try { \
                            \    return _ps.Either.Right(JSON.parse(str)); \
                            \  } catch (e) { \
                            \    return _ps.Either.Left(e.toString()); \
                            \  } \
                            \}" :: String -> Either String JSON
  
  foreign import readPrimType "function readPrimType (typeName) { \
                              \  return function (value) { \
                              \    if (toString.call(value) == '[object ' + typeName + ']') { \
                              \      return _ps.Either.Right(value);\
                              \    } \
                              \    return _ps.Either.Left('Value is not a ' + typeName + ''); \
                              \  }; \
                              \}" :: forall a. String -> JSON -> Either String a
                              
  foreign import readMaybe "function readMaybe (value) { \
                           \  return value === undefined || value === null ? _ps.Maybe.Nothing : _ps.Maybe.Just(value); \
                           \}" :: forall a. JSON -> Maybe.Maybe JSON
                              
  foreign import readProp "function readProp (k) { \
                          \  return function (obj) { \
                          \    return _ps.Either.Right(obj[k]);\
                          \  }; \
                          \}" :: forall a. String -> JSON -> Either String JSON
  
  foreign import showJSON "function showJSON (obj) { \
                          \  return JSON.stringify(obj); \
                          \}" :: JSON -> String
                      
  instance Prelude.Show JSON where
    show = showJSON
  
  data JSONParser a = JSONParser (JSON -> Either String a)
  
  str :: JSONParser String
  str = JSONParser $ readPrimType "String"
  
  num :: JSONParser Number
  num = JSONParser $ readPrimType "Number"
  
  bool :: JSONParser Boolean
  bool = JSONParser $ readPrimType "Boolean"
  
  arr :: JSONParser [JSON]
  arr = JSONParser $ readPrimType "Array"
  
  mayb :: JSONParser (Maybe.Maybe JSON)
  mayb = JSONParser $ Right <<< readMaybe
  
  prop :: String -> JSONParser JSON
  prop p = JSONParser \x -> readProp p x
  
  runParser :: forall a. JSONParser a -> JSON -> Either String a
  runParser (JSONParser p) x = p x
  
  instance Prelude.Monad JSONParser where
    return x = JSONParser \_ -> Right x
    (>>=) (JSONParser p) f = JSONParser \x -> case p x of
        Left err -> Left err
        Right x' -> runParser (f x') x
  
  instance Prelude.Applicative JSONParser where
    pure x = JSONParser \_ -> Right x
    (<*>) (JSONParser f) (JSONParser p) = JSONParser \x -> case f x of
        Left err -> Left err
        Right f' -> f' <$> p x
      
  instance Prelude.Functor JSONParser where
    (<$>) f (JSONParser p) = JSONParser \x -> f <$> p x
    
  class ReadJSON a where
    readJSON :: JSONParser a
    
  instance ReadJSON String where
    readJSON = str
    
  instance ReadJSON Number where
    readJSON = num
    
  instance ReadJSON Boolean where
    readJSON = bool
    
  instance (ReadJSON a) => ReadJSON [a] where
    readJSON = arr >>= \xs -> JSONParser $ \_ -> 
      readArrayItem `mapM` (zip (range 0 (length xs)) xs)
    
  readArrayItem :: forall a. (ReadJSON a) => Tuple Number JSON -> Either String a
  readArrayItem (Tuple i x) = case runParser readJSON x of
      Right result -> Right result
      Left err -> Left $ "Error reading item at index " ++ (show i) ++ ":\n" ++ err
    
  instance (ReadJSON a) => ReadJSON (Maybe a) where
    readJSON = mayb >>= \x -> JSONParser $ \_ -> case x of
      Just x' -> runParser readJSON x' >>= return <<< Just
      Nothing -> return Nothing
  
  readJSONProp :: forall a. (ReadJSON a) => String -> JSONParser a
  readJSONProp p = (prop p) >>= \x -> JSONParser $ \_ -> 
    case runParser readJSON x of
      Right result -> Right result
      Left err -> Left $ "Error reading property '" ++ p ++ "':\n" ++ err

  
module Main where

  import Prelude
  import JSON
  import Either
  import Monad
  import Maybe
  import Eff
  
  foreign import toJSON "function toJSON (obj) { return obj; }" :: forall a. a -> JSON

  showUnsafe :: forall a. a -> String
  showUnsafe = showJSON <<< toJSON
  
  data Object = Object { foo :: String
                       , bar :: Boolean
                       , baz :: Number
                       , list :: [ListItem] }
                       
  data ListItem = ListItem { x :: Number
                           , y :: Number
                           , z :: Maybe Number }
                           
  instance JSON.ReadJSON ListItem where
    readJSON = do
      x <- readJSONProp "x"
      y <- readJSONProp "y"
      z <- readJSONProp "z"
      return $ ListItem { x: x, y: y, z: z }
  
  instance JSON.ReadJSON Object where
    readJSON = do
      foo <- readJSONProp "foo"
      bar <- readJSONProp "bar"
      baz <- readJSONProp "baz"
      list <- readJSONProp "list"
      return $ Object { foo: foo, bar: bar, baz: baz, list: list }
      
  main = do
  
    let objPass = fromString "{\"foo\":\"hello\",\"bar\":true,\"baz\":1,\"list\":[{\"x\":1,\"y\":2},{\"x\":3,\"y\":4,\"z\":999}]}" 
    Trace.print $ case objPass of
      Left err ->  "Error parsing JSON string: " ++ err
      Right obj -> case runParser readJSON obj of
        Left err -> "Error parsing JSON object: " ++ err
        Right (Object result) -> showUnsafe result
    
    Trace.trace ""
    
    let objFail = fromString "{\"foo\":\"hello\",\"bar\":true,\"baz\":1,\"list\":[{\"x\":1,\"y\":2},{\"x\":3,\"y\":4,\"z\":false}]}" 
    Trace.print $ case objFail of
      Left err ->  "Error parsing JSON string: " ++ err
      Right obj -> case runParser readJSON obj of
        Left err -> "Error parsing JSON object: " ++ err
        Right (Object result) -> showUnsafe result