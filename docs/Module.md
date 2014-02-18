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

    instance Prelude.Applicative JSONParser

    instance Prelude.Functor JSONParser

    instance Prelude.Monad JSONParser

    instance Prelude.Show JSON

    instance ReadJSON Prim.String

    instance ReadJSON Prim.Number

    instance ReadJSON Prim.Boolean

    (ReadJSON (a)) => instance ReadJSON [a]

    (ReadJSON (a)) => instance ReadJSON Maybe a


### Values

    fromString :: Prim.String -> Either Prim.String JSON

    parseJSON :: forall a. (ReadJSON (a)) => Prim.String -> Either Prim.String a

    readJSONArrayItem :: forall a. (ReadJSON (a)) => Tuple Prim.Number JSON -> Either Prim.String a

    readJSONProp :: forall a. (ReadJSON (a)) => Prim.String -> JSONParser a

    readMaybe :: forall a. JSON -> Maybe.Maybe JSON

    readPrimType :: forall a. Prim.String -> JSON -> Either Prim.String a

    readProp :: forall a. Prim.String -> JSON -> Either Prim.String JSON

    runParser :: forall a. JSONParser a -> JSON -> Either Prim.String a

    showJSON :: JSON -> Prim.String



