# Module Documentation

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



