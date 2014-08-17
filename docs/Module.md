# Module Documentation

## Module Data.Foreign

### Types

    type F  = Either ForeignError

    data Foreign :: *

    data ForeignError where
      TypeMismatch :: String -> String -> ForeignError
      PropertyDoesNotExist :: String -> ForeignError
      IndexOutOfBounds :: Number -> ForeignError
      JSONError :: String -> ForeignError


### Type Class Instances

    instance showForeignError :: Show ForeignError


### Values

    isArray :: Foreign -> Boolean

    isNull :: Foreign -> Boolean

    isUndefined :: Foreign -> Boolean

    parseJSON :: String -> F Foreign

    readArray :: Foreign -> F [Foreign]

    readBoolean :: Foreign -> F Boolean

    readNumber :: Foreign -> F Number

    readString :: Foreign -> F String

    tagOf :: Foreign -> String

    toForeign :: forall a. a -> Foreign

    typeOf :: Foreign -> String

    unsafeFromForeign :: forall a. Foreign -> a


## Module Data.Foreign.Class

### Type Classes

    class IsForeign a where
      read :: Foreign -> F a


### Type Class Instances

    instance arrayIsForeign :: (IsForeign a) => IsForeign [a]

    instance booleanIsForeign :: IsForeign Boolean

    instance nullIsForeign :: (IsForeign a) => IsForeign (Null a)

    instance nullOrUndefinedIsForeign :: (IsForeign a) => IsForeign (NullOrUndefined a)

    instance numberIsForeign :: IsForeign Number

    instance stringIsForeign :: IsForeign String

    instance undefinedIsForeign :: (IsForeign a) => IsForeign (Undefined a)


### Values

    readJSON :: forall a. (IsForeign a) => String -> F a


## Module Data.Foreign.Index

### Type Classes

    class Index i where
      (!) :: Foreign -> i -> F Foreign
      hasProperty :: i -> Foreign -> Boolean
      hasOwnProperty :: i -> Foreign -> Boolean


### Type Class Instances

    instance indexNumber :: Index Number

    instance indexString :: Index String


### Values


## Module Data.Foreign.Keys

### Values

    keys :: Foreign -> F [String]


## Module Data.Foreign.Null

### Types

    newtype Null a where
      Null :: Maybe a -> Null a


### Values

    readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)

    runNull :: forall a. Null a -> Maybe a


## Module Data.Foreign.NullOrUndefined

### Types

    newtype NullOrUndefined a where
      NullOrUndefined :: Maybe a -> NullOrUndefined a


### Values

    readNullOrUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (NullOrUndefined a)

    runNullOrUndefined :: forall a. NullOrUndefined a -> Maybe a


## Module Data.Foreign.Undefined

### Types

    newtype Undefined a where
      Undefined :: Maybe a -> Undefined a


### Values

    readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)

    runUndefined :: forall a. Undefined a -> Maybe a