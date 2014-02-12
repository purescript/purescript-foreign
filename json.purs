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
                              \}" :: forall a. String -> JSONParser a
                              
  foreign import prop "function prop (k) { \
                      \  return function (obj) { \
                      \    if (obj.hasOwnProperty(k)) { \
                      \      return _ps.Either.Right(obj[k]);\
                      \    } \
                      \    return _ps.Either.Left('Unknown property ' + k + ''); \
                      \  }; \
                      \}" :: forall a. String -> JSONParser JSON
  
  foreign import showJSON "function showJSON (obj) { \
                          \  return JSON.stringify(obj); \
                          \}" :: JSON -> String
                      
  instance Prelude.Show JSON where
    show = showJSON
  
  type JSONParser a = JSON -> Either String a
  
  str :: JSONParser String
  str = readPrimType "String"
  
  num :: JSONParser Number
  num = readPrimType "Number"
  
  bool :: JSONParser Boolean
  bool = readPrimType "Boolean"
  
  arr :: JSONParser [JSON]
  arr = readPrimType "Array"
  
  arrOf :: forall a. JSONParser a -> JSONParser [a]
  arrOf t json = arr json >>= mapM t 
