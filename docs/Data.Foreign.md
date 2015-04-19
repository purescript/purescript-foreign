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
  | ErrorAtIndex Int ForeignError
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

#### `unsafeReadTagged`

``` purescript
unsafeReadTagged :: forall a. String -> Foreign -> F a
```

Unsafely coerce a `Foreign` value when the value has a particular `tagOf`
value.

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



