# Module Documentation
## Module Data.JSON

### Types

    data JSON :: *

    data JSONParser a where
      JSONParser :: JSON -> Either Prim.String a -> JSONParser a


### Type Classes

    class ReadJSON a where
      readJSON :: JSONParser a


### Type Class Instances

    instance applicativeJSONParser :: Prelude.Applicative JSONParser

    instance functorJSONParser :: Prelude.Functor JSONParser

    instance monadJSONParser :: Prelude.Monad JSONParser

    instance readJSONArray :: (ReadJSON a) => ReadJSON [a]

    instance readJSONBoolean :: ReadJSON Prim.Boolean

    instance readJSONMaybe :: (ReadJSON a) => ReadJSON (Maybe a)

    instance readJSONNumber :: ReadJSON Prim.Number

    instance readJSONString :: ReadJSON Prim.String

    instance showJSON :: Prelude.Show JSON


### Values

    parseJSON :: forall a. (ReadJSON a) => Prim.String -> Either Prim.String a

    readJSONProp :: forall a. (ReadJSON a) => Prim.String -> JSONParser a

    runParser :: forall a. JSONParser a -> JSON -> Either Prim.String a



