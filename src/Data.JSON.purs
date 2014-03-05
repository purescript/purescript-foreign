module Data.JSON where

import Prelude
import Data.Array
import Data.Either
import Data.Maybe
import Data.Tuple
import Control.Monad

foreign import data JSON :: *

foreign import fromString "function fromString (str) { \
                          \  try { \
                          \    return _ps.Data_Either.Right(JSON.parse(str)); \
                          \  } catch (e) { \
                          \    return _ps.Data_Either.Left(e.toString()); \
                          \  } \
                          \}" :: String -> Either String JSON

foreign import readPrimType "function readPrimType (typeName) { \
                            \  return function (value) { \
                            \    if (toString.call(value) == '[object ' + typeName + ']') { \
                            \      return _ps.Data_Either.Right(value);\
                            \    } \
                            \    return _ps.Data_Either.Left('Value is not a ' + typeName + ''); \
                            \  }; \
                            \}" :: forall a. String -> JSON -> Either String a
                            
foreign import readMaybe "function readMaybe (value) { \
                         \  return value === undefined || value === null ? _ps.Data_Maybe.Nothing : _ps.Data_Maybe.Just(value); \
                         \}" :: forall a. JSON -> Maybe JSON
                            
foreign import readProp "function readProp (k) { \
                        \  return function (obj) { \
                        \    return _ps.Data_Either.Right(obj[k]);\
                        \  }; \
                        \}" :: forall a. String -> JSON -> Either String JSON

foreign import showJSONImpl "function showJSONImpl (obj) { \
                            \  return JSON.stringify(obj); \
                            \}" :: JSON -> String
                    
instance showJSON :: Prelude.Show JSON where
  show = showJSONImpl

data JSONParser a = JSONParser (JSON -> Either String a)

runParser :: forall a. JSONParser a -> JSON -> Either String a
runParser (JSONParser p) x = p x

instance monadJSONParser :: Prelude.Monad JSONParser where
  return x = JSONParser \_ -> Right x
  (>>=) (JSONParser p) f = JSONParser \x -> case p x of
      Left err -> Left err
      Right x' -> runParser (f x') x

instance applicativeJSONParser :: Prelude.Applicative JSONParser where
  pure x = JSONParser \_ -> Right x
  (<*>) (JSONParser f) (JSONParser p) = JSONParser \x -> case f x of
      Left err -> Left err
      Right f' -> f' <$> p x
    
instance functorJSONParser :: Prelude.Functor JSONParser where
  (<$>) f (JSONParser p) = JSONParser \x -> f <$> p x
  
class ReadJSON a where
  readJSON :: JSONParser a
  
instance readJSONString :: ReadJSON String where
  readJSON = JSONParser $ readPrimType "String"
  
instance readJSONNumber :: ReadJSON Number where
  readJSON = JSONParser $ readPrimType "Number"
  
instance readJSONBoolean :: ReadJSON Boolean where
  readJSON = JSONParser $ readPrimType "Boolean"
  
instance readJSONArray :: (ReadJSON a) => ReadJSON [a] where
  readJSON = (JSONParser $ readPrimType "Array") >>= \xs -> JSONParser \_ -> 
    readJSONArrayItem `mapM` (zip (range 0 (length xs)) xs)
  
readJSONArrayItem :: forall a. (ReadJSON a) => Tuple Number JSON -> Either String a
readJSONArrayItem (Tuple i x) = case runParser readJSON x of
    Right result -> Right result
    Left err -> Left $ "Error reading item at index " ++ (show i) ++ ":\n" ++ err
  
instance readJSONMaybe :: (ReadJSON a) => ReadJSON (Maybe a) where
  readJSON = (JSONParser $ Right <<< readMaybe) >>= \x -> JSONParser \_ -> 
    case x of
      Just x' -> runParser readJSON x' >>= return <<< Just
      Nothing -> return Nothing

readJSONProp :: forall a. (ReadJSON a) => String -> JSONParser a
readJSONProp p = (JSONParser \x -> readProp p x) >>= \x -> JSONParser \_ -> 
  case runParser readJSON x of
    Right result -> Right result
    Left err -> Left $ "Error reading property '" ++ p ++ "':\n" ++ err
    
parseJSON :: forall a. (ReadJSON a) => String -> Either String a
parseJSON json = do
  obj <- fromString json
  runParser readJSON obj
