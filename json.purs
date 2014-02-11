module JSON where

  import Prelude
  import Either
  import Monad
  
  foreign import data JSON :: *
  
  foreign import fromString "function fromString (str) { \
                            \  try { \
                            \    return _ps.Either.Right(JSON.parse(str)); \
                            \  } catch (e) { \
                            \    return e.toString(); \
                            \  } \
                            \};" :: String -> Either String JSON
  
  foreign import showJSON "function showJSON (obj) { return JSON.stringify(obj); }" :: JSON -> String
  
  foreign import readPrimType "function readPrimType (typeName) { \
                              \  return function (value) { \
                              \    if (toString.call(value) == '[object ' + typeName + ']') { \
                              \      return _ps.Either.Right(value);\
                              \    } \
                              \    return _ps.Either.Left('Value is not a ' + typeName + ''); \
                              \  }; \
                              \};" :: forall a. String -> JSON -> Either String a
                              
  foreign import prop "function prop (k) { \
                      \  return function (obj) { \
                      \    if (obj.hasOwnProperty(k)) { \
                      \      return _ps.Either.Right(obj[k]);\
                      \    } \
                      \    return _ps.Either.Left('Unknown property ' + k + ''); \
                      \  }; \
                      \};" :: forall a. String -> JSON -> Either String JSON
                      
  instance Prelude.Show JSON where
    show = showJSON
    
  data JSONParser a = JSONParser (JSON -> Either String a)
  
  str :: JSON -> Either String String
  str = readPrimType "String"
  
  num :: JSON -> Either String Number
  num = readPrimType "Number"
  
  bool :: JSON -> Either String Boolean
  bool = readPrimType "Boolean"
  
  arr :: JSON -> Either String [JSON]
  arr = readPrimType "Array"
  
  arrOf :: forall a. (JSON -> Either String a) -> JSON -> Either String [a]
  arrOf t json = arr json >>= mapM t 
