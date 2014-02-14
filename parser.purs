module JSON where

  import Prelude
  import Either
  import Monad
  
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
                              
  foreign import readProp "function prop (k) { \
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
  
  maybe :: JSONParser (Maybe.Maybe JSON)
  maybe = JSONParser $ Right <<< readMaybe
  
  prop :: String -> JSONParser JSON
  prop p = JSONParser \x -> readProp p x
  
  runParser :: forall a. JSONParser a -> JSON -> Either String a
  runParser (JSONParser p) x = p x
  
  instance Prelude.Monad JSONParser where
    return x = JSONParser \_ -> Right x
    (>>=) (JSONParser p) f = JSONParser \x -> case p x of
        Left err -> Left err
        Right x' -> runParser (f x') x
  
