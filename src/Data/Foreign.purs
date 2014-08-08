module Data.Foreign
  ( Foreign(..)
  , ForeignParser(ForeignParser)
  , parseForeign
  , parseJSON
  , ReadForeign
  , read
  , prop
  , index
  , keys
  ) where

import Data.Array
import Data.Function
import Data.Either
import Data.Maybe
import Data.Tuple
import Data.Traversable

import Control.Monad.Eff.Exception (Error())

foreign import data Foreign :: *

foreign import fromStringImpl
  "function fromStringImpl(left, right, str) { \
  \  try { \
  \    return right(JSON.parse(str)); \
  \  } catch (e) { \
  \    return left(e.toString()); \
  \  } \
  \}" :: Fn3 (String -> Either String Foreign) (Foreign -> Either String Foreign) String (Either String Foreign)

fromString :: String -> Either String Foreign
fromString s = runFn3 fromStringImpl Left Right s

foreign import readPrimTypeImpl
  "function readPrimTypeImpl(left, right, typeName, value) { \
  \  if (toString.call(value) == '[object ' + typeName + ']') { \
  \    return right(value);\
  \  } \
  \  return left('Value is not a ' + typeName + ''); \
  \}" :: forall a. Fn4 (String -> Either String a) (a -> Either String a) String Foreign (Either String a)

readPrimType :: forall a. String -> Foreign -> Either String a
readPrimType ty x = runFn4 readPrimTypeImpl Left Right ty x

foreign import readMaybeImpl
  "function readMaybeImpl(nothing, just, value) { \
  \  return value === undefined || value === null ? nothing : just(value); \
  \}" :: forall a. Fn3 (Maybe Foreign) (Foreign -> Maybe Foreign) Foreign (Maybe Foreign)

readMaybeImpl' :: Foreign -> Maybe Foreign
readMaybeImpl' x = runFn3 readMaybeImpl Nothing Just x

-- We use == to check for both null and undefined
foreign import readPropImpl
  "function readPropImpl(k, obj) { \
  \    return obj == undefined ? undefined : obj[k];\
  \}" :: forall a. Fn2 a Foreign Foreign

readPropImpl' :: String -> Foreign -> Foreign
readPropImpl' prop x = runFn2 readPropImpl prop x

readIndexImpl' :: Number -> Foreign -> Foreign
readIndexImpl' index x = runFn2 readPropImpl index x

-- We use == to check for both null and undefined
foreign import readKeysImpl
  "function readKeysImpl(left, right, k, obj) { \
  \  if (obj == undefined) { \
  \    return left('cannot get a key from an undefined or null value'); \
  \  } else if (obj[k] == undefined) { \
  \    return left('value is undefined or null'); \
  \  } else if (Array.isArray(obj[k])) { \
  \    return left('value is an array'); \
  \  } else if (typeof obj[k] !== 'object') { \
  \    return left('value is not an object'); \
  \  } \
  \  return right(Object.keys(obj[k])); \
  \}"
  :: forall a. Fn4 (String -> Either String a) (a -> Either String a) String Foreign (Either String [String])

readKeysImpl' :: String -> Foreign -> Either String [String]
readKeysImpl' prop x = runFn4 readKeysImpl Left Right prop x

foreign import showForeignImpl
  "var showForeignImpl = JSON.stringify;" :: Foreign -> String

instance showForeign :: Prelude.Show Foreign where
  show = showForeignImpl

data ForeignParser a = ForeignParser (Foreign -> Either String a)

parseForeign :: forall a. ForeignParser a -> Foreign -> Either String a
parseForeign (ForeignParser p) x = p x

parseJSON :: forall a. (ReadForeign a) => String -> Either String a
parseJSON json = fromString json >>= parseForeign read

instance functorForeignParser :: Prelude.Functor ForeignParser where
  (<$>) f (ForeignParser p) = ForeignParser \x -> f <$> p x

instance bindForeignParser :: Prelude.Bind ForeignParser where
  (>>=) (ForeignParser p) f = ForeignParser \x -> case p x of
      Left err -> Left err
      Right x' -> parseForeign (f x') x

instance applyForeignParser :: Prelude.Apply ForeignParser where
  (<*>) (ForeignParser f) (ForeignParser p) = ForeignParser \x -> case f x of
      Left err -> Left err
      Right f' -> f' <$> p x

instance applicativeForeignParser :: Prelude.Applicative ForeignParser where
  pure x = ForeignParser \_ -> Right x

instance monadForeignParser :: Prelude.Monad ForeignParser

class ReadForeign a where
  read :: ForeignParser a

instance readString :: ReadForeign String where
  read = ForeignParser $ readPrimType "String"

instance readNumber :: ReadForeign Number where
  read = ForeignParser $ readPrimType "Number"

instance readBoolean :: ReadForeign Boolean where
  read = ForeignParser $ readPrimType "Boolean"

instance readError :: ReadForeign Error where
  read = ForeignParser $ readPrimType "Error"

instance readArray :: (ReadForeign a) => ReadForeign [a] where
  read = let
    arrayItem (Tuple i x) = case parseForeign read x of
      Right result -> Right result
      Left err -> Left $ "Error reading item at index " ++ (show i) ++ ":\n" ++ err
    in
    (ForeignParser $ readPrimType "Array") >>= \xs ->
      ForeignParser \_ -> arrayItem `traverse` (zip (range 0 (length xs)) xs)

instance readMaybe :: (ReadForeign a) => ReadForeign (Maybe a) where
  read = (ForeignParser $ Right <<< readMaybeImpl') >>= \x ->
    ForeignParser \_ -> case x of
      Just x' -> parseForeign read x' >>= return <<< Just
      Nothing -> return Nothing

prop :: forall a. (ReadForeign a) => String -> ForeignParser a
prop p = (ForeignParser \x -> Right $ readPropImpl' p x) >>= \x ->
  ForeignParser \_ -> case parseForeign read x of
    Right result -> Right result
    Left err -> Left $ "Error reading property '" ++ p ++ "':\n" ++ err

index :: forall a. (ReadForeign a) => Number -> ForeignParser a
index i = (ForeignParser \x -> Right $ readIndexImpl' i x) >>= \x ->
  ForeignParser \_ -> case parseForeign read x of
    Right result -> Right result
    Left err -> Left $ "Error reading index '" ++ show i ++ "':\n" ++ err

keys :: String -> ForeignParser [String]
keys p = ForeignParser \x -> case readKeysImpl' p x of
  Right result -> Right result
  Left err -> Left $ "Error reading object keys of '" ++ p ++ "':\n" ++ err
