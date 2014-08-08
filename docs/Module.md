# Module Documentation

## Module Data.Foreign

### Types

    data Foreign :: *

    data ForeignParser a where
      ForeignParser :: Foreign -> Either String a -> ForeignParser a


### Type Classes

    class ReadForeign a where
      read :: ForeignParser a


### Type Class Instances

    instance applicativeForeignParser :: Prelude.Applicative ForeignParser

    instance applyForeignParser :: Prelude.Apply ForeignParser

    instance bindForeignParser :: Prelude.Bind ForeignParser

    instance functorForeignParser :: Prelude.Functor ForeignParser

    instance monadForeignParser :: Prelude.Monad ForeignParser

    instance readArray :: (ReadForeign a) => ReadForeign [a]

    instance readBoolean :: ReadForeign Boolean

    instance readError :: ReadForeign Error

    instance readMaybe :: (ReadForeign a) => ReadForeign (Maybe a)

    instance readNumber :: ReadForeign Number

    instance readString :: ReadForeign String

    instance showForeign :: Prelude.Show Foreign


### Values

    index :: forall a. (ReadForeign a) => Number -> ForeignParser a

    keys :: String -> ForeignParser [String]

    parseForeign :: forall a. ForeignParser a -> Foreign -> Either String a

    parseJSON :: forall a. (ReadForeign a) => String -> Either String a

    prop :: forall a. (ReadForeign a) => String -> ForeignParser a