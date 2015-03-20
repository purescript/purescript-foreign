# Module Documentation

## Module Data.Foreign


This module defines types and functions for working with _foreign_
data.

#### `Foreign`

``` purescript
data Foreign :: *
```

A type for _foreign data_.

Foreign data is data from any external _unknown_ or _unreliable_
source, for which it cannot be guaranteed that the runtime representation
conforms to that of any particular type.

Suitable applications of `Foreign` are

- To represent responses from web services
- To integrate with external JavaScript libraries.

#### `ForeignError`

``` purescript
data ForeignError
  = TypeMismatch String String
  | ErrorAtIndex Number ForeignError
  | ErrorAtProperty String ForeignError
  | JSONError String
```

A type for runtime type errors

#### `showForeignError`

``` purescript
instance showForeignError :: Show ForeignError
```


#### `eqForeignError`

``` purescript
instance eqForeignError :: Eq ForeignError
```


#### `F`

``` purescript
type F = Either ForeignError
```

An error monad, used in this library to encode possible failure when
dealing with foreign data.

#### `parseJSON`

``` purescript
parseJSON :: String -> F Foreign
```

Attempt to parse a JSON string, returning the result as foreign data.

#### `toForeign`

``` purescript
toForeign :: forall a. a -> Foreign
```

Coerce any value to the a `Foreign` value.

#### `unsafeFromForeign`

``` purescript
unsafeFromForeign :: forall a. Foreign -> a
```

Unsafely coerce a `Foreign` value.

#### `typeOf`

``` purescript
typeOf :: Foreign -> String
```

Read the Javascript _type_ of a value

#### `tagOf`

``` purescript
tagOf :: Foreign -> String
```

Read the Javascript _tag_ of a value.

This function wraps the `Object.toString` method.

#### `isNull`

``` purescript
isNull :: Foreign -> Boolean
```

Test whether a foreign value is null

#### `isUndefined`

``` purescript
isUndefined :: Foreign -> Boolean
```

Test whether a foreign value is undefined

#### `isArray`

``` purescript
isArray :: Foreign -> Boolean
```

Test whether a foreign value is an array

#### `readString`

``` purescript
readString :: Foreign -> F String
```

Attempt to coerce a foreign value to a `String`.

#### `readBoolean`

``` purescript
readBoolean :: Foreign -> F Boolean
```

Attempt to coerce a foreign value to a `Boolean`.

#### `readNumber`

``` purescript
readNumber :: Foreign -> F Number
```

Attempt to coerce a foreign value to a `Number`.

#### `readArray`

``` purescript
readArray :: Foreign -> F [Foreign]
```

Attempt to coerce a foreign value to an array.


## Module Data.Foreign.Class


This module defines a type class for reading foreign values.

#### `IsForeign`

``` purescript
class IsForeign a where
  read :: Foreign -> F a
```

A type class instance for this class can be written for a type if it
is possible to attempt to _safely_ coerce a `Foreign` value to that
type.

Instances are provided for standard data structures, and the `F` monad
can be used to construct instances for new data structures.

#### `foreignIsForeign`

``` purescript
instance foreignIsForeign :: IsForeign Foreign
```


#### `stringIsForeign`

``` purescript
instance stringIsForeign :: IsForeign String
```


#### `booleanIsForeign`

``` purescript
instance booleanIsForeign :: IsForeign Boolean
```


#### `numberIsForeign`

``` purescript
instance numberIsForeign :: IsForeign Number
```


#### `arrayIsForeign`

``` purescript
instance arrayIsForeign :: (IsForeign a) => IsForeign [a]
```


#### `nullIsForeign`

``` purescript
instance nullIsForeign :: (IsForeign a) => IsForeign (Null a)
```


#### `undefinedIsForeign`

``` purescript
instance undefinedIsForeign :: (IsForeign a) => IsForeign (Undefined a)
```


#### `nullOrUndefinedIsForeign`

``` purescript
instance nullOrUndefinedIsForeign :: (IsForeign a) => IsForeign (NullOrUndefined a)
```


#### `readJSON`

``` purescript
readJSON :: forall a. (IsForeign a) => String -> F a
```

Attempt to read a data structure from a JSON string

#### `readWith`

``` purescript
readWith :: forall a e. (IsForeign a) => (ForeignError -> e) -> Foreign -> Either e a
```

Attempt to read a foreign value, handling errors using the specified function

#### `readProp`

``` purescript
readProp :: forall a i. (IsForeign a, Index i) => i -> Foreign -> F a
```

Attempt to read a property of a foreign value at the specified index


## Module Data.Foreign.Index


This module defines a type class for types which act like 
_property indices_.

#### `Index`

``` purescript
class Index i where
  (!) :: Foreign -> i -> F Foreign
  hasProperty :: i -> Foreign -> Boolean
  hasOwnProperty :: i -> Foreign -> Boolean
  errorAt :: i -> ForeignError -> ForeignError
```

This type class identifies types wich act like _property indices_.

The canonical instances are for `String`s and `Number`s.

#### `prop`

``` purescript
prop :: String -> Foreign -> F Foreign
```

Attempt to read a value from a foreign value property

#### `index`

``` purescript
index :: Number -> Foreign -> F Foreign
```

Attempt to read a value from a foreign value at the specified numeric index

#### `indexString`

``` purescript
instance indexString :: Index String
```


#### `indexNumber`

``` purescript
instance indexNumber :: Index Number
```



## Module Data.Foreign.Keys


This module provides functions for working with object properties
of Javascript objects.

#### `keys`

``` purescript
keys :: Foreign -> F [String]
```

Get an array of the properties defined on a foreign value


## Module Data.Foreign.Null

#### `Null`

``` purescript
newtype Null a
  = Null (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
null values.

Conceptually, this type represents values which may be `null`, 
but not `undefined`.

#### `runNull`

``` purescript
runNull :: forall a. Null a -> Maybe a
```

Unwrap a `Null` value 

#### `readNull`

``` purescript
readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)
```

Read a `Null` value


## Module Data.Foreign.NullOrUndefined

#### `NullOrUndefined`

``` purescript
newtype NullOrUndefined a
  = NullOrUndefined (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
null and undefined values.

Conceptually, this type represents values which may be `null`
or `undefined`.

#### `runNullOrUndefined`

``` purescript
runNullOrUndefined :: forall a. NullOrUndefined a -> Maybe a
```

Unwrap a `NullOrUndefined` value

#### `readNullOrUndefined`

``` purescript
readNullOrUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (NullOrUndefined a)
```

Read a `NullOrUndefined` value


## Module Data.Foreign.Undefined

#### `Undefined`

``` purescript
newtype Undefined a
  = Undefined (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
undefined values.

Conceptually, this type represents values which may be `undefined`, 
but not `null`.

#### `runUndefined`

``` purescript
runUndefined :: forall a. Undefined a -> Maybe a
```

Unwrap an `Undefined` value

#### `readUndefined`

``` purescript
readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)
```

Read an `Undefined` value